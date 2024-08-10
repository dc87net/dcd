import subprocess
import hashlib
import csv

# Function to get SHA-256 fingerprint from a certificate
def get_fingerprint(cert_pem):
    cert = subprocess.run(['openssl', 'x509', '-noout', '-fingerprint', '-sha256'],
                          input=cert_pem, text=True, capture_output=True)
    return cert.stdout.strip().split('=')[1].replace(':', '')

# Function to dump system keychain certificates
def dump_system_keychain():
    cmd = ['security', 'find-certificate', '-a', '-p', '/System/Library/Keychains/SystemRootCertificates.keychain']
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout

# Function to load known trusted roots from a CSV file
def load_trusted_roots(file_path):
    trusted_roots = {}
    with open(file_path, mode='r') as infile:
        reader = csv.reader(infile, delimiter='\t')
        next(reader)  # Skip header
        for rows in reader:
            if rows and rows[-1]:  # Check if the row is not empty and has a fingerprint
                fingerprint = rows[-1].replace(' ', '').upper()
                trusted_roots[fingerprint] = {'name': rows[0], 'issuer': rows[1]}
    return trusted_roots

# Compare system keychain certificates with trusted roots
def compare_certificates(system_certs, trusted_roots):
    discrepancies = []
    certs = system_certs.split('-----END CERTIFICATE-----\n')
    for cert in certs:
        if cert.strip():
            cert += '-----END CERTIFICATE-----\n'
            fingerprint = get_fingerprint(cert)
            if fingerprint not in trusted_roots:
                discrepancies.append(fingerprint)
    return discrepancies

# Path to the known trusted roots CSV file
trusted_roots_file = '/mnt/data/certs.csv'  # Update this path

# Load known trusted roots
trusted_roots = load_trusted_roots(trusted_roots_file)

# Dump system keychain certificates
system_certs = dump_system_keychain()

# Compare and find discrepancies
discrepancies = compare_certificates(system_certs, trusted_roots)

# Report discrepancies
if discrepancies:
    print("Discrepancies found:")
    for fp in discrepancies:
        print(f"Unknown certificate fingerprint: {fp}")
else:
    print("No discrepancies found. All certificates match the trusted list.")
