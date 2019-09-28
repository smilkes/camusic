drum_ring = (ring :drum_heavy_kick, :drum_tom_mid_soft, :drum_tom_mid_hard, 
             :drum_tom_lo_soft, :drum_tom_lo_hard, :drum_tom_hi_soft, 
             :drum_tom_hi_hard, :drum_splash_soft, :drum_splash_hard, 
             :drum_snare_soft, :drum_snare_hard, :drum_cymbal_soft,
             :drum_cymbal_hard, :drum_cymbal_open, :drum_cymbal_closed,
             :drum_cymbal_pedal, :drum_bass_soft, :drum_bass_hard,
             :drum_cowbell)

live_loop :foo do
  use_real_time
  my_notes = sync "/osc/trigger/notes"
  num_notes = my_notes.length
  counter = 0
  use_synth :mod_sine
  if my_notes.length > 0
    num_notes.times do
      play scale(:c4, :major, num_octaves: 3)[my_notes[counter]], release: 0.5, amp: 0.3
      #sample drum_ring[my_notes[counter]], release: 0.3
      counter = counter + 1
      sleep 0.1
    end
  end
end 