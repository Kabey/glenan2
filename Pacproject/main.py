#INIT DE PYGAME
import pygame
from pygame.locals import *

import pacman
from pacman import PacMan
import tile
from tile import Tile

pygame.init()

SCREENSIZE=(600,400)
screen = pygame.display.set_mode(SCREENSIZE, 0, 32)
#FIN INIT

#INIT SUPPLEMENTAIRE
clock=pygame.time.Clock()

background = pygame.surface.Surface(SCREENSIZE).convert()
background.fill((0,0,0))

pacman = PacMan((50,50), [500,200])
tile = Tile((150,150), [150,100])
tile2 = Tile((16,16), [300,300])

#GAMELOOP

while True:
	time_passed=clock.tick(30) #framerate du jeu
	#key_pressed=pygame.key.get_pressed()

	for event in pygame.event.get():
		if event.type == QUIT:
			exit()

	pacman.move()
	pacman.collide(tile)
	pacman.collide(tile2)


	screen.blit(background, (0,0))
	
	tile.draw(screen)
	tile2.draw(screen)
	pacman.draw(screen)


	#pygame.draw.circle(screen,(255,255,0),(x,y),16)
	pygame.display.update()
