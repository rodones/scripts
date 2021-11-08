from os import listdir
from os.path import isfile, join
import sqlite3
from datetime import datetime
from .lib.reader import r_readlines
from .lib.dict_entry import DictionaryEntry


def choose_last_log() -> str:

    name_last = "mvs_0000-00-00_00-00-00.txt"

    for f in listdir("logs"):
        if(isfile(join("logs", f))):
            if(f.split("_")[0] == "mvs"):
                if(compare_names(f, name_last)):
                    name_last = f

    return name_last


def compare_names(first: str, second: str) -> bool:
    splitted_dates1 = first.split(".")[0].split("_")
    splitted_dates2 = second.split(".")[0].split("_")
    val1 = splitted_dates1[1].split("-")
    val1.extend(splitted_dates1[2].split("-"))
    val2 = splitted_dates2[1].split("-")
    val2.extend(splitted_dates2[2].split("-"))

    result = False

    dates1 = [int(f) for f in val1]
    dates2 = [int(f) for f in val2]
    for i in range(len(dates1)):
        if(i == len(dates1)-1):
            if(dates1[i] > dates2[i]):
                result = True
                break
        if(dates1[i] < dates2[i]):
            break
    return result


def read_index(line: str):
    return int(line.split("index")[1].split("in")[0].strip())


def read_kp(line: str):
    return int(line.split("(")[1].split("points")[0].strip())

# TODO take file names from terminal


def prepare_mvs_keypoints():

    db = sqlite3.connect("output/database.db")

    count = [f for f in db.execute("SELECT COUNT(*) FROM images")][0][0]

    dict: list[DictionaryEntry] = [DictionaryEntry() for _ in range(count)]

    for image_id, name, data in db.execute(
            "SELECT kp.image_id, imgs.name, kp.rows " +
            "FROM keypoints as kp " +
            "JOIN images as imgs " +
            "ON imgs.image_id = kp.image_id " +
            "ORDER BY kp.rows"):
        dict[image_id-1] = DictionaryEntry(name, image_id-1, data)

    last_log = choose_last_log()

    gen = r_readlines("logs/"+last_log)

    index = 0
    kp = 0
    flag = True
    for line in gen:
        if("Starting fusion" in line):
            dict[index].mvs_keypoint = kp
            break
        if("Fusing image" in line):
            if(not flag):
                temp_kp = read_kp(line)
                dict[index].mvs_keypoint = kp - temp_kp
                kp = temp_kp
            elif(flag):
                kp = read_kp(line)
                flag = False
            index = read_index(line)
    gen.close()

    today = datetime.now()
    date_str = "{}-{}-{}_{}-{}-{}".format(today.year, today.month,
                                          today.day, today.hour,
                                          today.minute, today.second)
    log_file = open("output/logs/mvs_"+date_str+".txt", "w")

    log_file.write("{}\t{}{:>10}{:>10}\n".format("image_id",
                                                 "image_name".ljust(30),
                                                 "mvs", "sfm"))

    for entry in dict:
        log_file.write("{: 6}\t{}{:>10}{:>10}\n"
                       .format(entry.image_id+1, entry.image_name.ljust(30),
                               entry.mvs_keypoint, entry.sfm_keypoint))
    log_file.close()
    db.close()


def main() -> None:
    prepare_mvs_keypoints()


if __name__ == 'main':
    main()
