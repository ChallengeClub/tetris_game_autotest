import cv2
import time


# curl https://avatars.githubusercontent.com/${USER_NAME} --output output.png

# convert -resize 160x output.png output2.png

# 画像を3チャンネルカラー（BGR）として読み込み
#img = cv2.imread("test.jpg")
img = cv2.imread("output2.png")

# 画像を表示する
NAMETEST="nametest"
img_string="image_" + NAMETEST
#cv2.imshow('image',img)
cv2.imshow(img_string, img)

# キーボード入力を待つ
# killで強制終了させる
# xdotoolで画面を移動させる
cv2.waitKey(0)
time.sleep(10)

# すべてウィンドウを閉じる
cv2.destroyAllWindows()
