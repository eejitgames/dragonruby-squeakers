include AttrGTK

def reset
  $gtk.args.state.defaults_set = nil
end

def tick args
  self.args = args
  outputs.background_color = [ 10, 10, 10 ]
  set_defaults if state.defaults_set.nil?
  draw_room
  # outputs.debug << "room: #{state.room_number.to_s(16).upcase}"
  check_movement if args.state.tick_count.zmod? 10
end

# room numbers in the range of 0 - 1023, starting room is 339, the arrangement of rooms is 4 rooms tall, by 256 rooms wide
def check_movement
  if args.inputs.keyboard.left
    state.room_number -= 1
    state.room_number = 1023 if state.room_number == -1
  elsif args.inputs.keyboard.right
    state.room_number += 1
    state.room_number = 0 if state.room_number == 1024
  end

  if args.inputs.keyboard.down
    state.room_number += 256
    state.room_number -= 1024 if state.room_number > 1023
  elsif args.inputs.keyboard.up
    state.room_number -= 256
    state.room_number += 1024 if state.room_number < 0
  end
end

# function to draw all the walls for a given room
def draw_room
  draw_closed_door
  draw_outer_walls
  draw_inner_walls
end

# player can't go straight back out the way they came in
def draw_closed_door
end

# draw the outermost walls that do not change
def draw_outer_walls
  draw_wall_segment(x: 0, y: 0, dir: :N)
  draw_wall_segment(x: 0, y: 0, dir: :E)
  draw_wall_segment(x: 254, y: 0, dir: :E)
  draw_wall_segment(x: 762, y: 0, dir: :E)
  draw_wall_segment(x: 1016, y: 0, dir: :E)
  draw_wall_segment(x: 1270, y: 0, dir: :N)
  draw_wall_segment(x: 0, y: (10 + (680/3)) * 2, dir: :N)
  draw_wall_segment(x: 1270, y: (10 + (680/3)) * 2, dir: :N)
  draw_wall_segment(x: 0, y: (10 + (680/3)) * 3, dir: :E)
  draw_wall_segment(x: 254, y: (10 + (680/3)) * 3, dir: :E)
  draw_wall_segment(x: 762, y: (10 + (680/3)) * 3, dir: :E)
  draw_wall_segment(x: 1016, y: (10 + (680/3)) * 3, dir: :E)
end

# draw inner walls in room, forming a simple maze with wide corridors
def draw_inner_walls
  state.wall_seed = state.room_number
  draw_wall_segment(x: 254, y: (10 + (680/3)) * 2, dir: get_direction)
  draw_wall_segment(x: 508, y: (10 + (680/3)) * 2, dir: get_direction)
  draw_wall_segment(x: 762, y: (10 + (680/3)) * 2, dir: get_direction)
  draw_wall_segment(x: 1016, y: (10 + (680/3)) * 2, dir: get_direction)
  draw_wall_segment(x: 254, y: 10 + (680/3), dir: get_direction)
  draw_wall_segment(x: 508, y: 10 + (680/3), dir: get_direction)
  draw_wall_segment(x: 762, y: 10 + (680/3), dir: get_direction)
  draw_wall_segment(x: 1016, y: 10 + (680/3), dir: get_direction)
end

# this is a version of the generation system used in the arcade game berzerk - it follows the same patterns as the arcade game following a reset.
def get_direction
  n1 = 0x7
  n2 = 0x3153
  r1 = (state.wall_seed * n1) & 0xFFFF
  r2 = (r1 + n2) & 0xFFFF
  r3 = (r2 * n1) & 0xFFFF
  result = (r3 + n2) & 0xFFFF   
  state.wall_seed = result
  high_8_bits = (result >> 8) & 0xFF
  low_2_bits = high_8_bits & 0x03
  
  case low_2_bits
  when 0
    :N
  when 1
    :S
  when 2
    :E
  when 3
    :W
  end
end

# function to draw wall segments, pass the x, y coordinates, and the direction to draw the segment
def draw_wall_segment(x:, y:, dir:)
  case dir
  when :N
    outputs.solids  << { x: x, y: y, w: 10, h: 20 + (680/3), r: 10, g: 10, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  when :S
    outputs.solids  << { x: x, y: y - ((10 + (680/3))), w: 10, h: 20 + (680/3), r: 10, g: 10, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  when :E
    outputs.solids  << { x: x, y: y, w: 264, h: 10, r: 10, g: 10, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  when :W
    outputs.solids  << { x: x - 254, y: y, w: 264, h: 10, r: 10, g: 10, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  end
end

def set_defaults
  state.custom_tick_count = 0
  state.room_number = 0x0153
  state.defaults_set = true
end

$gtk.reset
