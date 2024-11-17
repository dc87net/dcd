import time
import sys


#log = logger.log

def spin(count=0, text="Please wait", spinnerChars=\
        ['🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘','🌑']):
        #'''Some other spinner options:'''
        #['-', '\\', '|', '/']):
        #['┤', '┘', '┴', '└', '├', '┌', '┬', '┐']):
        #['▙', '▌', '▛', '▀', '▐', '▟', '▄']):
        #['🌎', '🌍', '🌏']): #🌐

    # Calculate the index for the spinner character
    charIndex = count % len(spinnerChars)

    # Get the spinner character
    char = spinnerChars[charIndex]

    # Print the spinner character and text
    sys.stdout.write(f'\r{text}\t{char}\t\t\t')
    sys.stdout.flush()



# Sample function to simulate an operation being done after 5 seconds
def operation_complete(start_time):
    return time.time() > start_time + 25

if __name__ == "__main__":
    # This block will only run when the script is executed directly (not imported)
    start_time = time.time()
    count = 0
    try:
        while not operation_complete(start_time):
            spin(count, "Loading...")
            time.sleep(0.6)
            count += 1
    except KeyboardInterrupt:
        sys.stdout.write('\rOperation interrupted.')
        sys.stdout.flush()


# Uncomment the following lines to run the spinner until operation_complete returns True
'''
start_time = time.time()
count = 0
#chars = ['▄','▙','▌','▛','▘','▀','▝','▜','▐' ,'▟','▗']
#chars = ['▙', '▌', '▛', '▀', '▜', '▐', '▟', '▄']
#chars = ['🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘']
try:
    while not operation_complete():
        spin(count, "Loading...")
        time.sleep(0.6)
        count += 1
except KeyboardInterrupt:
    sys.stdout.write('\rOperation interrupted.')
    sys.stdout.flush()

'''

'''
In JavaScript:
let count = 0;

function spinner(text, spinnerChars = ['🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘']) {
  // Calculate the index for the spinner character
  let charIndex = count % spinnerChars.length;

  // Get the spinner character
  let char = spinnerChars[charIndex];

  // Update the spinner element in the DOM
  document.getElementById('spinner').innerText = `${char} ${charIndex}`;

  // Increment the count
  count++;

  // Set a delay before the next spinner frame
  setTimeout(() => spinner(text, spinnerChars), 600);
}

// Start the spinner
spinner("Loading...");

// HTML
// <div id="spinner"></div>
'''