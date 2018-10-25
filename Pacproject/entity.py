import pygame

from vectors import Vector2D


class AbstractEntity(object):
	def __init__(self, dim, pos):
		self.dim = dim
		self.pos = Vector2D(pos)
		self.COLOR = (0,0,0)

	def draw(self, screen):
		values = list(self.pos.toTuple()) + list(self.dim)
		pygame.draw.rect(screen, self.COLOR, values)
		
