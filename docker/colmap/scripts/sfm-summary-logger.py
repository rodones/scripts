import sqlite3
from datetime import datetime


def prepare_sfm_keypoints():
    db = sqlite3.connect("output/database.db")
    today = datetime.now()
    date_str = "{}-{}-{}_{}-{}-{}".format(today.year, today.month,
                                          today.day, today.hour,
                                          today.minute, today.second)
    log_file = open("output/logs/sfm_"+date_str+".txt", "w")

    log_file.write("{}\t{}\t{}\n"
                   .format("image_id", "image_name".ljust(30), "keypoints"))
    for image_id, name, data in db.execute(
            "SELECT kp.image_id, imgs.name, kp.rows" +
            "FROM keypoints as kp" +
            "JOIN images as imgs " +
            "ON imgs.image_id = kp.image_id" +
            "ORDER BY kp.rows"):
        log_file.write("{: 6}\t{}\t{}\n"
                       .format(image_id, name.ljust(30), data))

    log_file.close()
    db.close()


def main() -> None:
    prepare_sfm_keypoints()


if __name__ == 'main':
    main()
