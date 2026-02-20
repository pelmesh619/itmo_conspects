import matplotlib.pyplot as plt

def savefig(filename, ext='png'):
    try:
        plt.savefig(f"appliedmath/cvmethods/images/{filename}.{ext}")
    except Exception as e:
        print(f"Image {filename}.{ext} was not saved:", repr(e))

