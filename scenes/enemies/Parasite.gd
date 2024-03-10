class_name Parasite

extends BaseCreature

@export var duplication_energy = 1

var energy = 0

var duplicate_location: Vector2

var creature_type = CreatureType.Parasite

func on_move_entered():
    print_debug("Starting move")
    duplicate_location = position
    
func on_move_exited(success):
    if !success:
        print_debug("Move not successful!")
        return
        
    if energy >= duplication_energy:
        print_debug("Enough energy to duplicate")
        var new_parasite = self.duplicate()
        add_sibling(new_parasite)
        new_parasite.position = duplicate_location
        energy = 0
        

func consume_monster(monster):
    print_debug("Consuming ", monster)
    # When energy passes a threshold, spawn an identical parasite
    # Stronger monsters give more energy
    energy += monster.damage

func on_touched_by_player(player):
    player.receive_damage(damage)

func on_touched_by_monster(monster):
    monster.receive_damage(damage)
    if monster.dead():
        consume_monster(monster)
        
func on_touched_by_parasite(parasite):
    pass
    # TODO: Unsure if we want this or not
    #print_debug("Parasites are touching!")
    #if self.is_greater_than(parasite):
        #return
        #
    #health += parasite.health
    #parasite.health = 0
