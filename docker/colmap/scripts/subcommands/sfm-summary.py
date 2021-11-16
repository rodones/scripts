#!/usr/bin/env python3

from os.path import join
from sys import stdout
import sqlite3

BASE_DIR = join("/", "working")
LOGS_DIR = join(BASE_DIR, "logs")
DB_PATH = join(BASE_DIR, "output", "database.db")


def prepare_sfm_keypoints():
    db = sqlite3.connect(DB_PATH)

    query = "SELECT kp.image_id, imgs.name, kp.rows " \
        "FROM keypoints as kp " \
        "JOIN images as imgs ON imgs.image_id = kp.image_id " \
        "ORDER BY kp.rows"

    stdout.write("{}\t{}\t{}\n".format("image_id", "image_name".ljust(30), "keypoints"))
    try:
        for image_id, name, data in db.execute(query):
            stdout.write("{: 6}\t{}\t{}\n".format(image_id, name.ljust(30), data))
    except (BrokenPipeError, IOError):
        pass

    try:
        stdout.close()
    except IOError:
        pass

    db.close()


if __name__ == '__main__':
    prepare_sfm_keypoints()
