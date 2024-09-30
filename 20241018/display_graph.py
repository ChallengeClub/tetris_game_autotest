import matplotlib.pyplot as plt
import numpy as np
from argparse import ArgumentParser
import pickle

def get_option(file1, file2, outputfile):
    argparser = ArgumentParser()
    argparser.add_argument('--file1', type=str,
                           default=file1,
                           help='file1')
    argparser.add_argument('--file2', type=str,
                           default=file2,
                           help='file2')
    argparser.add_argument('--outputfile', type=str,
                           default=outputfile,
                           help='outputfile')
    return argparser.parse_args()

# get filename of file1, file2
file1 = "nofile"
file2 = "nofile"
outputfile = "output_graph.png"
args = get_option(file1, file2, outputfile)
file1 = args.file1
file2 = args.file2
outputfile = args.outputfile

# try to open file1,file2
try:
    with open(file1, 'rb') as f:
        score_list1 = pickle.load(f)
        uname1 = file1.split("scorelistfile_")[-1]
        uname1 = uname1.split(".")[0]
except:
    # no file
    score_list1 = None
try:
    # try to open current file
    with open(file2, 'rb') as f:
        score_list2 = pickle.load(f)
        uname2 = file2.split("_")[-1]
        uname2 = uname2.split(".")[0]
except:
    # no file
    score_list2 = None

# error case
if score_list1 == None and score_list2 == None:
    print("No specified files, exit...")
    print("file1: ", file1)
    print("file2: ", file2)
    exit(0)
#score_list1 = [0.3, 1.2, 1.3, 1.8, 1.7, 1.5]
#score_list2 = [2.1, 2.4, 2.3, 2.1, 2.2, 2.1, 33]
gene_1 = np.array(score_list1)
if score_list2 != None:
    gene_2 = np.array(score_list2)

# plot graph
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
# plot
#ax.plot(x, gene_1, label='player1(left)')
#ax.plot(x, gene_2, label='player2(right)')
ax.plot(gene_1, label=uname1)
if score_list2 != None:
    ax.plot(gene_2, label=uname2)
# set label
ax.legend()
ax.set_xlabel("time[sec]")
ax.set_ylabel("score")
# set ylim
max_score = max(score_list1)
min_score = min(score_list1)
if score_list2 != None:
    max_score = max(max_score, max(score_list2))
    min_score = min(min_score, min(score_list2))
max_score = (max_score+2000)//1 # clip
min_score = (min_score-100)//1 # clip
ax.set_ylim(min_score, max_score)

#plt.figure(figsize=(4,3), dpi=50)
save_name = outputfile # "scoregraph_" + uname1 + uname2 + ".png"
plt.savefig(save_name)
# show
#plt.show()
