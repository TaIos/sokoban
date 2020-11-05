from pygame.constants import KEYDOWN, K_LEFT, K_RIGHT, K_DOWN, K_UP

import constants as SOKOBAN
import pygame as pg


def pddl_solver():
    pass


class Solution:
    def __init__(self, level, board):
        self.actions = []
        self.position = -1

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
