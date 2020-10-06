import os
import atexit
import readline

readline_history_file = os.path.join(os.path.expanduser('~'), 'history', 'python_history')
try:
    readline.read_history_file(readline_history_file)
except IOError:
    pass

readline.set_history_length(0)
atexit.register(readline.write_history_file, readline_history_file)
