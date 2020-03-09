HighTone = dotsPlayableNote();
HighTone.frequency = 1000;
HighTone.duration = 3;
HighTone.intensity = 1;
HighTone.prepareToPlay();
HighTone.play();
pause(HighTone.duration);

pause(1);

LowTone = dotsPlayableNote();
LowTone.frequency = 400;
LowTone.duration = 3;
LowTone.intensity = 1;
LowTone.prepareToPlay();
LowTone.play();
pause(LowTone.duration);