import cv2
import time
from argparse import ArgumentParser

def get_option(user_name, image_name):
    argparser = ArgumentParser()
    argparser.add_argument('-u', '--user_name', type=str,
                           default=user_name,
                           help='player name')
    argparser.add_argument('-i', '--image_name', type=str,
                           default=image_name,
                           help='image name')
    return argparser.parse_args()

user_name="testuser"
image_name="output2.png"
args = get_option(user_name,
                  image_name)

if len(args.user_name) != 0:
    user_name = args.user_name
if len(args.image_name) != 0:
    image_name = args.image_name

# curl https://avatars.githubusercontent.com/${USER_NAME} --output output.png

# convert -resize 160x output.png output2.png

# 画像を3チャンネルカラー（BGR）として読み込み
#img = cv2.imread("test.jpg")
#img = cv2.imread("output2.png")
img = cv2.imread(image_name)
#img = cv2.imread("test.png")

# 画像を表示する
img_string="Image_" + user_name
#cv2.imshow('image',img)
cv2.imshow(img_string, img)

# キーボード入力を待つ
# killで強制終了させる
# xdotoolで画面を移動させる
cv2.waitKey(0)
time.sleep(10)

# すべてウィンドウを閉じる
cv2.destroyAllWindows()
