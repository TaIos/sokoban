from pygame.constants import KEYDOWN, K_LEFT, K_RIGHT, K_DOWN, K_UP
from helper import serialize_2D

import constants as SOKOBAN
import pygame as pg
from jinja2 import Template


def parse_grid(level):
    grid = level.structure
    grid_parsed = {"box": [], "player": None, "target": [], "air": [], "path": []}
    max_y = len(grid)
    for y in range(max_y):
        max_x = len(grid[y])
        for x in range(max_x):
            if grid[y][x] in [SOKOBAN.AIR, SOKOBAN.BOX, SOKOBAN.TARGET]:
                grid_parsed["air"].append(serialize_2D(y, x))

                # add correct paths

                # LEFT
                if (x - 1) >= 0 and grid[y][x - 1] in [SOKOBAN.AIR, SOKOBAN.BOX, SOKOBAN.TARGET]:
                    grid_parsed["path"].append((serialize_2D(y, x), serialize_2D(y, x - 1)))

                # RIGHT
                if (x + 1) < max_x and grid[y][x + 1] in [SOKOBAN.AIR, SOKOBAN.BOX, SOKOBAN.TARGET]:
                    grid_parsed["path"].append((serialize_2D(y, x), serialize_2D(y, x + 1)))

                # UP
                if (y + 1) < max_y and grid[y + 1][x] in [SOKOBAN.AIR, SOKOBAN.BOX, SOKOBAN.TARGET]:
                    grid_parsed["path"].append((serialize_2D(y, x), serialize_2D(y + 1, x)))

                # DOWN
                if (y - 1) >= 0 and grid[y - 1][x] in [SOKOBAN.AIR, SOKOBAN.BOX, SOKOBAN.TARGET]:
                    grid_parsed["path"].append((serialize_2D(y, x), serialize_2D(y - 1, x)))

            if grid[y][x] == SOKOBAN.BOX:
                grid_parsed["box"].append(serialize_2D(y, x))
            if grid[y][x] == SOKOBAN.TARGET:
                grid_parsed["target"].append(serialize_2D(y, x))
            if grid[y][x] == SOKOBAN.WALL:
                pass
    px, py = level.position_player
    grid_parsed["player"] = serialize_2D(py, px)
    return grid_parsed


def generate_pddl_task_file(level):
    grid_parsed = parse_grid(level)

    # prepare PDDL components

    objects = ""
    for obj in grid_parsed["air"]:
        objects += obj + " "
    objects += "- location"

    boxes = ""
    for box in grid_parsed["box"]:
        boxes += "(is_box_at " + box + ") "

    goals = ""
    for goal in grid_parsed["target"]:
        goals += "(is_box_at " + goal + ") "

    paths = ""
    for path in grid_parsed["path"]:
        paths += "(path " + path[0] + " " + path[1] + ") "

    player = "(at " + grid_parsed["player"] + ") "

    # render PDDL using jinja markup
    with open("pddl/task_jinja_template.pddl") as file_:
        template = Template(file_.read())
    render = template.render(objects=objects, path=paths, is_box_at=boxes, player=player, goal=goals)

    # save result
    with open("pddl/task.pddl", "w") as f:
        f.write(render)


def run_solver():
    pass


def extract_path_from_sas():
    return [FakePygameEvent.UP, FakePygameEvent.UP]


def pddl_solver(level, board):
    generate_pddl_task_file(level)
    run_solver()
    path = extract_path_from_sas()

    return path


class Solution:
    def __init__(self, level, board):
        self.actions = pddl_solver(level, board)
        self.position = 0

    def has_next(self):
        if 0 <= self.position < len(self.actions):
            return True

    def next(self):
        r = self.actions[self.position]
        self.position += 1
        return r


class FakePygameEvent:
    LEFT = pg.event.Event(pg.KEYDOWN, {"key": K_LEFT})
    RIGHT = pg.event.Event(pg.KEYDOWN, {"key": K_RIGHT})
    DOWN = pg.event.Event(pg.KEYDOWN, {"key": K_DOWN})
    UP = pg.event.Event(pg.KEYDOWN, {"key": K_UP})
