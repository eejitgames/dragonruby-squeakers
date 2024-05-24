include AttrGTK

def reset
  $gtk.args.state.defaults_set = nil
end

def tick args
  self.args = args
  outputs.background_color = [ 10, 10, 10 ]
  set_defaults if state.defaults_set.nil?
  draw_room
  outputs.debug << "room: #{state.room_number}"
  check_movement if args.state.tick_count.zmod? 10
end

# function to draw all the walls for a given room
def draw_room
  state.room_grid ||= Array.new(state.rows) { Array.new(state.cols, 0) }
  draw_outer_wall_solids
  draw_inner_wall_solids
  # draw_wall_debug
  draw_outer_wall_sprites
  draw_inner_wall_sprites
  draw_wall_junctions_sprites
end

# room numbers in the range of 0 - 1023, starting room is 339, the arrangement of rooms is 4 rooms tall, by 256 rooms wide
def check_movement
  state.pressed = 0
  if args.inputs.keyboard.left
    state.pressed = 1  
    state.room_number -= 1
    state.room_number = 1023 if state.room_number == -1
  elsif args.inputs.keyboard.right
    state.pressed = 1
    state.room_number += 1
    state.room_number = 0 if state.room_number == 1024
  end

  if args.inputs.keyboard.down
    state.pressed = 1
    state.room_number += 256
    state.room_number -= 1024 if state.room_number > 1023
  elsif args.inputs.keyboard.up
    state.pressed = 1
    state.room_number -= 256
    state.room_number += 1024 if state.room_number < 0
  end
  
  state.room_grid = nil if state.pressed == 1
end

# draw the outermost walls that do not change
def draw_outer_wall_solids
  draw_wall_segment_solids(x: 3,  y: 4,  dir: :N)
  draw_wall_segment_solids(x: 3,  y: 30, dir: :N)
  draw_wall_segment_solids(x: 78, y: 4,  dir: :N)
  draw_wall_segment_solids(x: 78, y: 30, dir: :N)
  draw_wall_segment_solids(x: 3,  y: 4,  dir: :E)
  draw_wall_segment_solids(x: 3,  y: 43, dir: :E)
  draw_wall_segment_solids(x: 18, y: 4,  dir: :E)
  draw_wall_segment_solids(x: 18, y: 43, dir: :E)
  draw_wall_segment_solids(x: 48, y: 4,  dir: :E)
  draw_wall_segment_solids(x: 48, y: 43, dir: :E)
  draw_wall_segment_solids(x: 63, y: 4,  dir: :E)
  draw_wall_segment_solids(x: 63, y: 43, dir: :E)
end

# draw inner walls in room, forming a simple maze with wide corridors
def draw_inner_wall_solids
  state.wall_seed = state.room_number
  draw_wall_segment_solids(x: 18, y: 30, dir: get_direction)
  draw_wall_segment_solids(x: 33, y: 30, dir: get_direction)
  draw_wall_segment_solids(x: 48, y: 30, dir: get_direction)
  draw_wall_segment_solids(x: 63, y: 30, dir: get_direction)
  draw_wall_segment_solids(x: 18, y: 17, dir: get_direction)
  draw_wall_segment_solids(x: 33, y: 17, dir: get_direction)
  draw_wall_segment_solids(x: 48, y: 17, dir: get_direction)
  draw_wall_segment_solids(x: 63, y: 17, dir: get_direction)
end

# draw the outermost walls that do not change
def draw_outer_wall_sprites
  draw_wall_segment_sprites(x: 3,  y: 4,  dir: :N)
  draw_wall_segment_sprites(x: 3,  y: 30, dir: :N)
  draw_wall_segment_sprites(x: 78, y: 4,  dir: :N)
  draw_wall_segment_sprites(x: 78, y: 30, dir: :N)
  draw_wall_segment_sprites(x: 3,  y: 4,  dir: :E)
  draw_wall_segment_sprites(x: 3,  y: 43, dir: :E)
  draw_wall_segment_sprites(x: 18, y: 4,  dir: :E)
  draw_wall_segment_sprites(x: 18, y: 43, dir: :E)
  draw_wall_segment_sprites(x: 48, y: 4,  dir: :E)
  draw_wall_segment_sprites(x: 48, y: 43, dir: :E)
  draw_wall_segment_sprites(x: 63, y: 4,  dir: :E)
  draw_wall_segment_sprites(x: 63, y: 43, dir: :E)

  outputs.sprites <<  { x: 1 * 16,  y: 2 * 16, w: 48, h: 48, path: "sprites/wall_5.png" }
  outputs.sprites <<  { x: 1 * 16,  y: 42 * 16 - 16, w: 48, h: 48, path: "sprites/wall_12.png" }
  outputs.sprites <<  { x: 76 * 16, y: 42 * 16 - 16, w: 48, h: 48, path: "sprites/wall_10.png" }
  outputs.sprites <<  { x: 76 * 16, y: 2 * 16, w: 48, h: 48, path: "sprites/wall_3.png" }

  outputs.sprites << { x: 31 * 16,  y: 2 * 16,  w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 32, y: 3)}.png" }
  outputs.sprites << { x: 31 * 16,  y: 41 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 32, y: 42)}.png" }
  outputs.sprites << { x: 46 * 16,  y: 2 * 16,  w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 47, y: 3)}.png" }
  outputs.sprites << { x: 46 * 16,  y: 41 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 47, y: 42)}.png" }

  outputs.sprites << { x: 16 * 16,  y: 2 * 16,  w: 48, h: 48, path: "sprites/wall_6.png" }
  outputs.sprites << { x: 16 * 16,  y: 41 * 16, w: 48, h: 48, path: "sprites/wall_6.png" }
  outputs.sprites << { x: 61 * 16,  y: 2 * 16,  w: 48, h: 48, path: "sprites/wall_6.png" }
  outputs.sprites << { x: 61 * 16,  y: 41 * 16, w: 48, h: 48, path: "sprites/wall_6.png" }

  outputs.sprites << { x: 1 * 16,   y: 15 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 2, y: 16)}.png" }
  outputs.sprites << { x: 1 * 16,   y: 28 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 2, y: 29)}.png" }
  outputs.sprites << { x: 76 * 16,  y: 15 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 77, y: 16)}.png" }
  outputs.sprites << { x: 76 * 16,  y: 28 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 77, y: 29)}.png" }
end

# draw inner walls in room, forming a simple maze with wide corridors
def draw_inner_wall_sprites
  state.wall_seed = state.room_number
  draw_wall_segment_sprites(x: 18, y: 30, dir: get_direction)
  draw_wall_segment_sprites(x: 33, y: 30, dir: get_direction)
  draw_wall_segment_sprites(x: 48, y: 30, dir: get_direction)
  draw_wall_segment_sprites(x: 63, y: 30, dir: get_direction)
  draw_wall_segment_sprites(x: 18, y: 17, dir: get_direction)
  draw_wall_segment_sprites(x: 33, y: 17, dir: get_direction)
  draw_wall_segment_sprites(x: 48, y: 17, dir: get_direction)
  draw_wall_segment_sprites(x: 63, y: 17, dir: get_direction)
end

def draw_wall_junctions_sprites
  outputs.sprites << { x: 31 * 16, y: 41 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 32, y: 42)}.png" }
  outputs.sprites << { x: 46 * 16, y: 41 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 47, y: 42)}.png" }
  outputs.sprites << { x: 1 * 16 , y: 15 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x:  2, y: 16)}.png" }
  outputs.sprites << { x: 1 * 16 , y: 28 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x:  2, y: 29)}.png" }

  outputs.sprites << { x: 16 * 16, y:  2 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 17, y:  3)}.png" }
  outputs.sprites << { x: 16 * 16, y: 41 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 17, y: 42)}.png" }
  outputs.sprites << { x: 61 * 16, y:  2 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 62, y:  3)}.png" }
  outputs.sprites << { x: 61 * 16, y: 41 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 62, y: 42)}.png" }

  outputs.sprites << { x: 31 * 16, y: 15 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 32, y: 16)}.png" }
  outputs.sprites << { x: 46 * 16, y: 15 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 47, y: 16)}.png" }
  outputs.sprites << { x: 61 * 16, y: 15 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 62, y: 16)}.png" }
  outputs.sprites << { x: 16 * 16, y: 15 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 17, y: 16)}.png" }
  outputs.sprites << { x: 31 * 16, y: 28 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 32, y: 29)}.png" }
  outputs.sprites << { x: 46 * 16, y: 28 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 47, y: 29)}.png" }
  outputs.sprites << { x: 61 * 16, y: 28 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 62, y: 29)}.png" }
  outputs.sprites << { x: 16 * 16, y: 28 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 17, y: 29)}.png" }

  outputs.sprites << { x: 76 * 16, y: 15 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 77, y: 16)}.png" }
  outputs.sprites << { x: 76 * 16, y: 28 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 77, y: 29)}.png" }
  outputs.sprites << { x: 31 * 16, y:  2 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 32, y:  3)}.png" }
  outputs.sprites << { x: 46 * 16, y:  2 * 16, w: 48, h: 48, path: "sprites/wall_#{choose_junction_sprite(x: 47, y:  3)}.png" }
end

# function to draw wall segments, pass in the x, y coordinates, and the direction to draw the segment
def draw_wall_segment_solids(x:, y:, dir:)
  case dir
  when :N
    outputs.solids   <<  { x: (x - 1) * 16, y: (y - 1) * 16, w: 16, h: state.segment_height, r: 10, g: 100, b: 200 }
    14.times do |i|
      # align the room_grid array with what is presented on the screen
      # state.room_grid[ 45 - (y + i) ][ x - 1 ] = 1
      state.room_grid[ y - 1 + i ][ x - 1 ] = 1
    end
  when :S
    outputs.solids   <<  { x: (x - 1) * 16, y: ((y - 1) * 16) - state.segment_height + 16, w: 16, h: state.segment_height, r: 10, g: 100, b: 200 }
    14.times do |i|
      # state.room_grid[ (45 + 13) - (y + i) ][ x - 1 ] = 1
      state.room_grid[ y + i - 14 ][ x - 1 ] = 1
    end
  when :E
    outputs.solids   <<  { x: (x - 1) * 16, y: (y - 1) * 16, w: state.segment_width, h: 16, r: 10, g: 100, b: 200 }
    16.times do |i|
      # state.room_grid[ 45 - y ][ x + i - 1] = 1
      state.room_grid[ y - 1][ x + i - 1] = 1
    end
  when :W
    outputs.solids   <<  { x: ((x - 1) * 16) - state.segment_width + 16, y: (y - 1) * 16, w: state.segment_width, h: 16, r: 10, g: 100, b: 200 }
    16.times do |i|
      # state.room_grid[ 45 - y ][ x + i - 16] = 1
      state.room_grid[ y - 1][ x + i - 16] = 1
    end
  end
end

def draw_wall_segment_sprites(x:, y:, dir:)
  case dir
  when :N
    4.times do |i|
      outputs.sprites <<  { x: (x - 2) * 16, y: y * 16 + (i * 48), w: 48, h: 48, path: "sprites/wall_9.png" }
    end
  when :S
    4.times do |i|
      outputs.sprites <<  { x: (x - 2) * 16, y: y * 16 + (i * 48) - state.segment_height + 16, w: 48, h: 48, path: "sprites/wall_9.png" }
    end
  when :E
    4.times do |i|
      outputs.sprites <<  { x: (x + 1) * 16 + (i * 48), y: (y - 2) * 16, w: 48, h: 48, path: "sprites/wall_6.png" }
    end
  when :W
    4.times do |i|
      outputs.sprites <<  { x: (x + 1) * 16 + (i * 48) - state.segment_width + 16, y: (y - 2) * 16, w: 48, h: 48, path: "sprites/wall_6.png" }
    end
  end
end

def choose_junction_sprite(x:, y:)
  # we want to check the game grid coordinates at x: 3, y: 4, this is at x: 2, y: 3 in 2d array, since 0, 0 is bottom left corner
  n = (state.room_grid[y + 1][x] == 1) ? 1 : 0
  s = (state.room_grid[y - 1][x] == 1) ? 1 : 0
  e = (state.room_grid[y][x + 1] == 1) ? 1 : 0
  w = (state.room_grid[y][x - 1] == 1) ? 1 : 0

  # puts60 "room_grid #{x}, #{y}: #{state.room_grid[y][x]}"
  # puts60 "n #{n} s #{s} e #{e} w #{w}"
  # puts60 "#{s}#{e}#{w}#{n}".to_i(2)

  # puts60 "#{state.room_grid[6][0]} #{state.room_grid[6][1]} #{state.room_grid[6][2]} #{state.room_grid[6][3]} #{state.room_grid[6][4]} #{state.room_grid[6][5]}"
  # puts60 "#{state.room_grid[5][0]} #{state.room_grid[5][1]} #{state.room_grid[5][2]} #{state.room_grid[5][3]} #{state.room_grid[5][4]} #{state.room_grid[5][5]}"
  # puts60 "#{state.room_grid[4][0]} #{state.room_grid[4][1]} #{state.room_grid[4][2]} #{state.room_grid[4][3]} #{state.room_grid[4][4]} #{state.room_grid[4][5]}"
  # puts60 "#{state.room_grid[3][0]} #{state.room_grid[3][1]} #{state.room_grid[3][2]} #{state.room_grid[3][3]} #{state.room_grid[3][4]} #{state.room_grid[3][5]}"
  # puts60 "#{state.room_grid[2][0]} #{state.room_grid[2][1]} #{state.room_grid[2][2]} #{state.room_grid[2][3]} #{state.room_grid[2][4]} #{state.room_grid[2][5]}"
  # puts60 "#{state.room_grid[1][0]} #{state.room_grid[1][1]} #{state.room_grid[1][2]} #{state.room_grid[1][3]} #{state.room_grid[1][4]} #{state.room_grid[1][5]}"
  # puts60 "#{state.room_grid[0][0]} #{state.room_grid[0][1]} #{state.room_grid[0][2]} #{state.room_grid[0][3]} #{state.room_grid[0][4]} #{state.room_grid[0][5]}"
  "#{s}#{e}#{w}#{n}".to_i(2) # return autotile bits in decimal form
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

def draw_wall_debug
  x = 16
  y = 15 * 16
  count = 0
  while count < 12
    outputs.solids << { x: x, y: y, w: 48, h: 48, r: 100, g: 100, b: 200 }
    x += state.segment_width - 16
    if x > 1280
      x = 16
      y += 13 * 16
    end
    count += 1
  end

  # show the junction points, and example sprite position at junction
  outputs.solids << { x: 31 * 16, y: 2 * 16,  w: 48, h: 48, r: 100, g: 100, b: 200 }
  outputs.solids << { x: 31 * 16, y: 41 * 16, w: 48, h: 48, r: 100, g: 100, b: 200 }
  outputs.solids << { x: 46 * 16, y: 2 * 16,  w: 48, h: 48, r: 100, g: 100, b: 200 }
  outputs.solids << { x: 46 * 16, y: 41 * 16, w: 48, h: 48, r: 100, g: 100, b: 200 }

  outputs.solids << { x: 16 * 16, y: 2 * 16,  w: 48, h: 48, r: 100, g: 100, b: 200 }
  outputs.solids << { x: 16 * 16, y: 41 * 16, w: 48, h: 48, r: 100, g: 100, b: 200 }
  outputs.solids << { x: 61 * 16, y: 2 * 16,  w: 48, h: 48, r: 100, g: 100, b: 200 }
  outputs.solids << { x: 61 * 16, y: 41 * 16, w: 48, h: 48, r: 100, g: 100, b: 200 }

  outputs.solids << { x: 32 * 16, y: 42 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 47 * 16, y: 42 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 2 * 16,  y: 16 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 2 * 16,  y: 29 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }

  outputs.solids << { x: 17 * 16, y: 3 * 16,  w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 17 * 16, y: 42 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 62 * 16, y: 3 * 16,  w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 62 * 16, y: 42 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }

  outputs.solids << { x: 32 * 16, y: 16 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 47 * 16, y: 16 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 62 * 16, y: 16 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 17 * 16, y: 16 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 32 * 16, y: 29 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 47 * 16, y: 29 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 62 * 16, y: 29 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 17 * 16, y: 29 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }

  outputs.solids << { x: 77 * 16, y: 16 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 77 * 16, y: 29 * 16, w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 32 * 16, y: 3 * 16,  w: 16, h: 16, r: 200, g: 200, b: 200 }
  outputs.solids << { x: 47 * 16, y: 3 * 16,  w: 16, h: 16, r: 200, g: 200, b: 200 }

  # draw debug grid
  x = 16
  y = 32
  while x < 1280
    outputs.solids << { x: x, y: y, w: 2, h: 672, r: 100, g: 100, b: 200 }
    x += 16
  end

  x = 16
  y = 32
  while y < 720
    outputs.solids << { x: x, y: y, w: 1248, h: 2, r: 100, g: 100, b: 200 }
    y += 16
  end

  # temp debug to console on room change
  if state.pressed == 1
    puts "=================="
    state.room_grid.reverse_each { |row| p row }
    puts "=================="
  end
end

def set_defaults
  state.rows = 45 # 720 / 16
  state.cols = 80 # 1280 / 16
  state.room_grid = nil
  state.segment_height = 16 * 12 + 2 * 16
  state.segment_width = 16 * 14 + 2 * 16
  state.room_number = 0x0153
  state.defaults_set = true
end

$gtk.reset
