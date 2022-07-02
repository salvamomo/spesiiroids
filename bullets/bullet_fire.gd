extends Bullet

func _on_Bullet_collision(body):
	if (body.has_method('hit_by_bullet')):
		body.call('hit_by_bullet')
