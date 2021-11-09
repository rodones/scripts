

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
