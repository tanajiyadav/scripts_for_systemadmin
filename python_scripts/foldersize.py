import locale
import os

locale.setlocale(locale.LC_ALL, "")

def get_size(state, root, names):
    paths = [os.path.realpath(os.path.join(root, n)) for n in names]
    # handles dangling symlinks
    state[0] += sum(os.stat(p).st_size for p in paths if os.path.exists(p))

def print_sizes(root):
    total = 0
    paths = []
    state = [0]
    n_ind = s_ind = 0
    for name in sorted(os.listdir(root)):
        path = os.path.join(root, name)
        if not os.path.isdir(path):
            continue
        state[0] = 0
        os.path.walk(path, get_size, state)
        total += state[0]
        s_size = locale.format('%8.0f', state[0], 3)
        n_ind = max(n_ind, len(name), 5)
        s_ind = max(s_ind, len(s_size))
        paths.append((name, s_size))

    for name, size in paths:
        print name.ljust(n_ind), size.rjust(s_ind), 'byte'
    s_total = locale.format('%8.0f', total/1024/1024, 3)
    print '\ntotal'.ljust(n_ind), s_total.rjust(s_ind), 'MB'
print_sizes('.')
