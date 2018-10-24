"""
commentaires
"""

#INIT DE PYGAME
import pygame
from pygame.locals import *
import pacman

pygame.init()

SCREENSIZE=(600,400)
screen = pygame.display.set_mode(SCREENSIZE, 0, 32)
#FIN INIT

#INIT SUPPLEMENTAIRE
clock=pygame.time.Clock()

background = pygame.surface.Surface(SCREENSIZE).convert()
background.fill((0,0,0))

#Pacman tile
x, y = (300,200)
width = 32
height = 32
xcollide = False
ycollide = False
xycollide = False
direction = 'LEFT'

#Tile rouge
x2 = 50
y2 = 50
width2 = 150
height2 = 100 


#FONCTION COLLISION

def axis_overlap(p1,length1,p2,length2):
	collided = False
	if p1 < p2:
		if p2+length2-p1 < length1+length2:
			collided = True
	elif p1 > p2:
		if p1+length1-p2 < length1+length2:
			collided = True
	elif p1 == p2:
		collided = True
	return collided


#GAMELOOP

while True:
	time_passed=clock.tick(30)/1000.0 #framerate du jeu
	key_pressed=pygame.key.get_pressed()

	for event in pygame.event.get():
		if event.type == QUIT:
			exit()
	if key_pressed[K_UP]:
		y-=3
		direction = 'UP'
	elif key_pressed[K_DOWN]:
		y+=3
		direction = 'DOWN'
	elif key_pressed[K_LEFT]:
		x-=3
		direction = 'LEFT'
	elif key_pressed[K_RIGHT]:
		x+=3    
		direction = 'RIGHT'


	screen.blit(background, (0,0))
	
	xcollide = axis_overlap(x,width,x2,width2)
	ycollide = axis_overlap(y,height,y2,height2)
	xycollide = xcollide & ycollide

	if xycollide:
		if direction is 'UP':
			y=y2+height2
		elif direction is 'DOWN':
			y=y2-height
		elif direction is 'LEFT':
			x=x2+width2
		elif direction is 'RIGHT':
			x=x2-width
		pygame.draw.rect(screen,(100,100,100),[x2,y2,width2,height2])
	else:
		pygame.draw.rect(screen,(255,0,0),[x2,y2,width2,height2])

	#pygame.draw.rect(screen,(255,0,0),[x2,y2,width2,height2])
	pygame.draw.rect(screen,(0,0,255),[400,300,60,80])
	pygame.draw.rect(screen,(255,255,0),[x,y,width,height])

	pygame.draw.line(screen,(255,0,0),(x2,10),(x2+width2,10),2)
	pygame.draw.line(screen,(255,0,0),(10,y2),(10,y2+height2),2)

	pygame.draw.line(screen,(0,0,255),(400,20),(460,20),2)
	pygame.draw.line(screen,(0,0,255),(20,300),(20,380),2)

	pygame.draw.line(screen,(255,255,0),(x,15),(x+width,15),2)
	pygame.draw.line(screen,(255,255,0),(15,y),(15,y+height),2)
	#pygame.draw.circle(screen,(255,255,0),(x,y),16)
	pygame.display.update()
