import pygame
from pygame.locals import *

from entity import AbstractEntity


class Tile(AbstractEntity):
	def __init__(self, dim, pos=[0,0]):
		AbstractEntity.__init__(self, dim, pos)
		self.COLOR = (255,0,0)
