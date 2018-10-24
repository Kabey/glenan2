class PacMan(object):
	def __init__(self,dim,pos=[0,0]):
		self.dim = dim
		self.pos = pos
		self.COLOR = (255,255,0)
		self.direction = 'LEFT'

	def move(self):
		key_pressed=pygame.key.get_pressed()
		if key_pressed[K_UP]:
			self.pos[1]-=3
			self.direction='UP'
		elif key_pressed[K_DOWN]:
			self.pos[1]+=3
			self.direction='DOWN'
		elif key_pressed[K_LEFT]:
			self.pos[0]-=3
			self.direction='LEFT'
		elif key_pressed[K_RIGHT]:
			self.pos[0]+=3
			self.direction='RIGHT'
	def collide(self,other):
		xcollide = axis_overla