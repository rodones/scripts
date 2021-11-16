#!/usr/bin/env python3

from os.path import join
import sqlite3

BASE_DIR = join("/", "working")
LOGS_DIR = join(BASE_DIR, "logs")
DB_PATH = join(BASE_DIR, "output", "database.db")


def prepare_sfm_keypoints():
    db = sqlite3.connect(DB_PATH)

    print("{}\t{}\t{}\n".format("image_id", "image_name".ljust(30), "keypoints"),
          flush=True)
    try:
        for image_id, name, data in db.execute(
                "SELECT kp.image_id, imgs.name, kp.rows " +
                "FROM keypoints as kp " +
                "JOIN images as imgs " +
                "ON imgs.image_id = kp.image_id " +
                "ORDER BY kp.rows"):
            print("{: 6}\t{}\t{}".format(image_id, name.ljust(30), data),
                  flush=True)
    except BrokenPipeError:
        pass
    db.close()


if __name__ == '__main__':
    prepare_sfm_keypoints()
