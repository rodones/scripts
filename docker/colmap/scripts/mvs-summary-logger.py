from os import listdir
from os.path import isfile, join
import os
import sqlite3
from datetime import datetime


class DictionaryEntry:
    image_name: str
    image_id: int
    sfm_keypoint: int
    mvs_keypoint: int

    def __init__(self, name: str = "", id: int = 0,
                 sfm: int = 0, mvs: int = 0) -> None:
        self.image_name = name
        self.mvs_keypoint = mvs
        self.image_id = id
        self.sfm_keypoint = sfm


def reverse_readline(filename, buf_size=8192):
    """A generator that returns the lines of a file in reverse order"""
    with open(filename) as fh:
        segment = None
        offset = 0
        fh.seek(0, os.SEEK_END)
        file_size = remaining_size = fh.tell()
        while remaining_size > 0:
            offset = min(file_size, offset + buf_size)
            fh.seek(file_size - offset)
            buffer = fh.read(min(remaining_size, buf_size))
            remaining_size -= buf_size
            lines = buffer.split('\n')
            # The first line of the buffer is probably not a complete line so
            # we'll save it and append it to the last line of the next buffer
            # we read
            if segment is not None:
                # If the previous chunk starts right from the beginning of line
                # do not concat the segment to the last line of new chunk.
                # Instead, yield the segment first
                if buffer[-1] != '\n':
                    lines[-1] += segment
                else:
                    yield segment
            segment = lines[0]
            for index in range(len(lines) - 1, 0, -1):
                if lines[index]:
                    yield lines[index]
        # Don't yield None if the file was empty
        if segment is not None:
            yield segment


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

    gen = reverse_readline("logs/"+last_log)

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
