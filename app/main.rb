include AttrGTK

def reset
  $gtk.args.state.defaults_set = nil
end

def tick args
  self.args = args
  outputs.background_color = [ 10, 10, 10 ]
  set_defaults if state.defaults_set.nil?
  # outputs.primitives << args.layout.debug_primitives
  draw_room
  outputs.debug << "room: #{state.room_number.to_s(16).upcase}"
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
  # state.array_of_wall_rects = []
  draw_outer_wall_sprites
  draw_inner_wall_sprites_debug
  draw_inner_wall_sprites
  # draw_closed_door
  # draw_outer_walls
  # draw_inner_walls
  # draw_wall_junctions
  # draw_diagonal_test
  # puts state.array_of_wall_rects
  # puts "==========="
  # create_room_array if args.state.tick_count.zmod? 600
end

def draw_inner_wall_sprites_debug
  x = 16 * 16
  y = 15 * 16
  count = 0

  # puts "============="
  while count < 8
    outputs.solids << { x: x, y: y, w: 48, h: 48, r: 100, g: 100, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    x += state.segment_width + state.wall_width
    if x > 1200
      x = 16 * 16
      y += 13 * 16
    end
    # puts "x: #{x}"
    # puts "y: #{y}"
    # puts "outputs.solids << { x: #{x + 16}, y: #{y + 16}, w: 16, h: 16, r: 200, g: 200, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }"

    count += 1
  end
  # puts "============="

  outputs.solids << { x: 512, y: 256, w: 16, h: 16, r: 200, g: 200, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  outputs.solids << { x: 752, y: 256, w: 16, h: 16, r: 200, g: 200, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  outputs.solids << { x: 992, y: 256, w: 16, h: 16, r: 200, g: 200, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  outputs.solids << { x: 272, y: 256, w: 16, h: 16, r: 200, g: 200, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  outputs.solids << { x: 512, y: 464, w: 16, h: 16, r: 200, g: 200, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  outputs.solids << { x: 752, y: 464, w: 16, h: 16, r: 200, g: 200, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  outputs.solids << { x: 992, y: 464, w: 16, h: 16, r: 200, g: 200, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
  outputs.solids << { x: 272, y: 464, w: 16, h: 16, r: 200, g: 200, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }

  # draw debug grid
  x = 16
  y = 32

  while x < 1280
    outputs.solids << { x: x, y: y, w: 2, h: 672, r: 100, g: 100, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    x += 16
  end

  x = 16
  y = 32

  while y < 720
    outputs.solids << { x: x, y: y, w: 1248, h: 2, r: 100, g: 100, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    y += 16
  end
end

def draw_inner_wall_sprites
end

def draw_outer_wall_sprites
  x = 16
  y = 32
  outputs.sprites << { x: x, y: y, w: 48, h: 48, path: "sprites/wall_5.png" }
  outputs.sprites << { x: x + (10 * 48), y: y, w: 48, h: 48, path: "sprites/wall_6.png" } # 2
  outputs.sprites << { x: x + (15 * 48), y: y, w: 48, h: 48, path: "sprites/wall_6.png" } # 4
  outputs.sprites << { x: x + (10 * 48), y: y + (13 * 48), w: 48, h: 48, path: "sprites/wall_6.png" } # 2
  outputs.sprites << { x: x + (15 * 48), y: y + (13 * 48), w: 48, h: 48, path: "sprites/wall_6.png" } # 4
  outputs.sprites << { x: x, y: y + (13 * 48), w: 48, h: 48, path: "sprites/wall_12.png" }
  count = 1
  while count < 25
    if count > 9 && count < 16
      count += 1
      next
    end
    outputs.sprites << { x: x + (count * 48), y: y, w: 48, h: 48, path: "sprites/wall_6.png" }
    outputs.sprites << { x: x + (count * 48), y: y + (13 * 48), w: 48, h: 48, path: "sprites/wall_6.png" }
    count += 1
  end
  outputs.sprites << { x: x + (count * 48), y: y, w: 48, h: 48, path: "sprites/wall_3.png" }
  outputs.sprites << { x: x + (count * 48), y: y + (13 * 48), w: 48, h: 48, path: "sprites/wall_10.png" }
  
  count = 1
  while count < 13
    if count > 3 && count < 9
      count += 1
      next
    end
    outputs.sprites << { x: x, y: y + (count * 48), w: 48, h: 48, path: "sprites/wall_9.png" }
    outputs.sprites << { x: x + (25 * 48), y: y + (count * 48), w: 48, h: 48, path: "sprites/wall_9.png" }
    count += 1
  end
  outputs.sprites << { x: x, y: y - 16 + (9 * 48), w: 48, h: 48, path: "sprites/wall_1.png" }
  outputs.sprites << { x: x + (25 * 48), y: y - 16 + (9 * 48), w: 48, h: 48, path: "sprites/wall_1.png" }  
  outputs.sprites << { x: x, y: y -16 + (4 * 48), w: 48, h: 48, path: "sprites/wall_9.png" }
  outputs.sprites << { x: x + (25 * 48), y: y -16 + (4 * 48), w: 48, h: 48, path: "sprites/wall_9.png" }  
  outputs.sprites << { x: x, y: y + 16 + (4 * 48), w: 48, h: 48, path: "sprites/wall_8.png" }
  outputs.sprites << { x: x + (25 * 48), y: y + 16 + (4 * 48), w: 48, h: 48, path: "sprites/wall_8.png" }  
end

# player can't go straight back out the way they came in
def draw_closed_door
end

# draw the outermost walls that do not change
def draw_outer_walls
  draw_wall_segment(x: 0, y: 0, dir: :N)
  draw_wall_segment(x: 0, y: 0, dir: :E)
  draw_wall_segment(x: state.segment_width + state.wall_width, y: 0, dir: :E)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 3, y: 0, dir: :E)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 4, y: 0, dir: :E)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 5, y: 0, dir: :N)
  draw_wall_segment(x: 0, y: (state.segment_height + state.wall_height) * 2, dir: :N)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 5, y: (state.segment_height + state.wall_height) * 2, dir: :N)
  draw_wall_segment(x: 0, y: (state.segment_height + state.wall_height) * 3, dir: :E)
  draw_wall_segment(x: state.segment_width + state.wall_width, y: (state.segment_height + state.wall_height) * 3, dir: :E)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 3, y: (state.segment_height + state.wall_height) * 3, dir: :E)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 4, y: (state.segment_height + state.wall_height) * 3, dir: :E)
end

# draw inner walls in room, forming a simple maze with wide corridors
def draw_inner_walls
  state.wall_seed = state.room_number
  draw_wall_segment(x: state.segment_width + state.wall_width, y: (state.segment_height + state.wall_height) * 2, dir: get_direction)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 2, y: (state.segment_height + state.wall_height) * 2, dir: get_direction)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 3, y: (state.segment_height + state.wall_height) * 2, dir: get_direction)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 4, y: (state.segment_height + state.wall_height) * 2, dir: get_direction)
  draw_wall_segment(x: state.segment_width + state.wall_width, y: state.segment_height + state.wall_height, dir: get_direction)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 2, y: state.segment_height + state.wall_height, dir: get_direction)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 3, y: state.segment_height + state.wall_height, dir: get_direction)
  draw_wall_segment(x: (state.segment_width + state.wall_width) * 4, y: state.segment_height + state.wall_height, dir: get_direction)
end

def draw_wall_junctions
  start_x = state.x_offset
  start_y = state.y_offset
  count = 0

  while count < 24
    outputs.solids << { x: start_x, y: start_y, w: state.wall_width, h: state.wall_height, r: 100, g: 100, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    start_x += state.segment_width + state.wall_width
    if start_x > 1280
      start_x = state.x_offset
      start_y += state.segment_height + state.wall_height
    end
    count += 1
  end
end

def draw_diagonal_test
  start_x = state.x_offset
  start_y = state.y_offset
  count = 0

  while start_x < 1280
    outputs.solids << { x: start_x, y: start_y, w: state.wall_width, h: state.wall_height, r: 100, g: 100, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    start_x += state.wall_width * 2
    start_y += state.wall_height
  end
end

def create_room_array
  start_x = state.x_offset - state.wall_width
  start_y = 720 - 8
  count = 0

  while start_y >= 0
    outputs.solids << { x: start_x, y: start_y, w: state.wall_width / 2, h: state.wall_height / 2, r: 100, g: 100, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    
    if geometry.find_intersect_rect( { x: start_x, y: start_y, w: state.wall_width / 2, h: state.wall_height / 2 }, state.array_of_wall_rects )
      print 1
    else
      print 0
    end
    
    start_x += state.wall_width
    if start_x > 1280 - state.x_offset
      start_x = state.x_offset - state.wall_width
      start_y -= state.wall_height
      print "\n"
    end
  end
  puts "===================================="
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
    outputs.solids << { x: x + state.x_offset, y: y + state.y_offset, w: state.wall_width, h: state.segment_height + (2 * state.wall_height), r: 10, g: 10, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    state.array_of_wall_rects += [{ x: x + state.x_offset, y: y + state.y_offset, w: state.wall_width, h: state.segment_height + (2 * state.wall_height)}]
  when :S
    outputs.solids << { x: x + state.x_offset, y: y + state.y_offset - state.segment_height - state.wall_height, w: state.wall_width, h: state.segment_height + (state.wall_height * 2), r: 10, g: 10, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    state.array_of_wall_rects += [{ x: x + state.x_offset, y: y + state.y_offset - state.segment_height - state.wall_height, w: state.wall_width, h: state.segment_height + (state.wall_height * 2)}]
  when :E
    outputs.solids << { x: x + state.x_offset, y: y + state.y_offset, w: state.segment_width + (2 * state.wall_width), h: state.wall_height, r: 10, g: 10, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    state.array_of_wall_rects += [{ x: x + state.x_offset, y: y + state.y_offset, w: state.segment_width + (2 * state.wall_width), h: state.wall_height}]
  when :W
    outputs.solids << { x: x + state.x_offset - state.segment_width, y: y + state.y_offset, w: state.segment_width + state.wall_width, h: state.wall_height, r: 10, g: 10, b: 200, a: 255, anchor_x: 0, anchor_y: 0, blendmode_enum: 1 }
    state.array_of_wall_rects += [{ x: x + state.x_offset - state.segment_width, y: y + state.y_offset, w: state.segment_width + state.wall_width, h: state.wall_height}]
  end
end

def set_defaults
  state.array_of_wall_rects = []
  state.wall_width = 16
  state.wall_height = 16
  state.segment_height = 16 * 13
  state.segment_width = 16 * 14
  state.x_offset = 28
  state.y_offset = 24
  state.custom_tick_count = 0
  state.room_number = 0x0153
  state.defaults_set = true
end

$gtk.reset
