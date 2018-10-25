import pygame
from pygame.locals import *

from entity import AbstractEntity
from vectors import Vector2D


class PacMan(AbstractEntity):
	def __init__(self,dim,pos=Vector2D(0,0)):
		AbstractEntity.__init__(self, dim, pos)
		self.COLOR = (255,255,0)
		self.direction = 'LEFT'
		self.collided = False

	def move(self):
		key_pressed=pygame.key.get_pressed()

		if key_pressed[K_UP]:
			self.pos.y-=3
			self.direction='UP'
		elif key_pressed[K_DOWN]:
			self.pos.y+=3
			self.direction='DOWN'
		elif key_pressed[K_LEFT]:
			self.pos.x-=3
			self.direction='LEFT'
		elif key_pressed[K_RIGHT]:
			self.pos.x+=3
			self.direction='RIGHT'

	def axis_overlap(self,p1,length1,p2,length2):
		self.collided = False
		if p1 < p2:
			if p2+length2-p1 < length1+length2:
				self.collided = True
		elif p1 > p2:
			if p1+length1-p2 < length1+length2:
				self.collided = True
		elif p1 == p2:
			self.collided = True
		return self.collided

	def collide(self,other):
		xcollide = self.axis_overlap(self.pos.x,self.dim[0],other.pos.x,other.dim[0])
		ycollide = self.axis_overlap(self.pos.y,self.dim[1],other.pos.y,other.dim[1])
		if xcollide & ycollide:
			if self.direction is 'UP':
				self.pos.y=other.pos.y+other.dim[1]
			elif self.direction is 'DOWN':
				self.pos.y=other.pos.y-other.dim[1]
			elif self.direction is 'LEFT':
				self.pos.x=other.pos.x+other.dim[0]
			elif self.direction is 'RIGHT':
				self.pos.x=other.pos.x-other.dim[0]
