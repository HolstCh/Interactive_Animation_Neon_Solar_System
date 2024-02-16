/**

 Neon Solar System

 Keyboard Input:
 Typing letter from 1/4 alphabet sets: add 1/4 planet types to neon solar system (all have orbits drawn and different shapes)
 Typing a vowel: decreases the radius of that planet type (depends on alphabet set) 
 Typing a consonant: increases the radius of that planet type (depends on alphabet set)
 Backspace or delete key: remove most recently added planet (or asteroid) from solar system
 1,2,3,4 or 5: rotates planet type or asteroid clockwise (CW)
 6,7,8, 9, 0: rotates planet type or asteroid counterclockwise (CCW)
 Spacebar: four falling/shooting stars that go off bottom of screen, start at mouse location
 Enter: reset solar system to default (big bang)
 Typing punctuation from exclamation mark, comma, period, or question mark: add a yellow, red, purple, or teal asteroid (no orbit drawn and all the same circular shape)

 Mouse Input:
 Left mouse click: decrease size of every existing planet
 Right mouse click: increase size of every existing planet
 Mouse dynamic location: falling stars will start at the location of the mouse on the screen (must press spacebar to make stars fall)
 
 **/

// define 4 arrays (4 approximate vertical sections on the keyboard that will create planets)
char[] earthLetters = {'q', 'a', 'z', 'w', 's', 'x'};
char[] marsLetters = {'e', 'd', 'c', 'r', 'f', 'v'};
char[] jupiterLetters = {'t', 'g', 'b', 'y', 'h', 'n','u'};
char[] saturnLetters = { 'o', 'j', 'm', 'i', 'k', 'l', 'p'};

// define booleans for Clockwise (CW) direction of circular path
boolean earthCW = true;
boolean marsCW = true;
boolean jupiterCW = true;
boolean saturnCW = true;
boolean asteroidCW = true;

// define array of Planets, their position vector, and the change of their orbit radius
ArrayList<Planet> solarSystem = new ArrayList<Planet>();
PVector planetPosition; // inital planet position
float radiusChange = 0.04;

// neon stars and their (x,y) coordinates for the background
int totalStars = 400;
PVector[] starCoordinates = new PVector[totalStars];

// neon colors used to make the neon solar system
color neonOrange = color(255, 140, 0);
color neonYellow = color(255, 255, 0);
color neonPink = color(251, 72, 196);
color neonRed = color(247, 33, 25);
color neonBlue = color(0, 188, 227);
color neonPurple = color(199, 36, 177);
color neonGreen = color(57, 255, 20);
color neonTeal = color(0, 255, 200);

float starStaticStartX, starStaticStartY;  // store the starting coordinate of the shooting star (near mouse location and when spacebar is pressed)
float starDynamicEndX, starDynamicEndY;  // store the ending point of the shooting star (changes until off screen)
boolean renderFallingStars = false; // determine if stars are falling, enables rendering

// variables for increasing ellipse size to simulate big bang animation
boolean bigBang = false; // enables rendering of big bang animation
int bigBangSize = 20; // current size of ellipses
int maxBigBangSize = 800; // max size of ellipses

void setup()
{
    size(800, 600); // create a canvas of size 800x600 pixels
    planetPosition = new PVector(height/1.5, height/2.5); // set initial planet position offset from top
    float x,y;
    for (int i = 0; i < totalStars; i++) // store random star coordinates
    {
      x = random(width);
      y = random(height);
      starCoordinates[i] = new PVector(x, y);
    }
}

// renders the neon background stars that have coordinates made in setup()
void renderBackgroundStars()
{
    strokeWeight(2);
    int count = 0;
    for (int i = 0; i < totalStars; i++) 
    {
     if(count == 0)
        stroke(neonPurple);
     else if(count == 1)
        stroke(neonYellow);
     else if(count == 2)
        stroke(neonPink);
     else if(count == 3)
        stroke(neonBlue);
     else if(count == 4)
        stroke(neonGreen);
     else if(count == 5)
        stroke(neonOrange);
     else if(count == 6)
        stroke(neonRed);
     else if(count == 7)
        stroke(neonTeal);
      count++;
      if(count == 8)
        count = 0;
      point(starCoordinates[i].x, starCoordinates[i].y);
    }
    strokeWeight(1);
}
void draw()
{  
    background(0); // set background to black
    renderBackgroundStars();
    if(!bigBang)
    {
      noStroke();
      fill(neonYellow);
      ellipse(width/2, height/2, 50, 50); // draw neon yellow sun in the center
    }
    for (Planet planet : solarSystem)  // iterate through the planets to update their rotation (radius or direction) and render the planets each time draw() is called
    {
        if (planet.type == "earth")
        {
            if(earthCW)
                planet.updateCW();
            else
                planet.updateCCW();
        }
        else if (planet.type == "jupiter")
        {
            if(jupiterCW)
                planet.updateCW();
            else
                planet.updateCCW();
        }
        else if (planet.type == "saturn")
        {
            if(saturnCW)
                planet.updateCW();
            else
                planet.updateCCW();
        }
        else if (planet.type == "mars")
        {
            if(marsCW)
                planet.updateCW();
            else
                planet.updateCCW();
        }
        else if (planet.type == "asteroid")
        {
          if(asteroidCW)
                planet.updateCW();
            else
                planet.updateCCW();
        }
        planet.render();
    }
    if(bigBang)
    {
      // draw the explosion
      fill(neonRed);
      ellipse(width/2, height/2, bigBangSize+200, bigBangSize+200);
      fill(neonOrange);
      ellipse(width/2, height/2, bigBangSize, bigBangSize);
      
      if (bigBangSize > 200)
      {
        fill(neonYellow);
        ellipse(width/2, height/2, bigBangSize-200, bigBangSize-200);
      }
     
       bigBangSize += 5;  // increase the big bang size
      // reset the explosion if it reaches the maximum size
      if (bigBangSize > maxBigBangSize)
      {
        bigBangSize = 10;
        bigBang = false;
      }
    }
    if (renderFallingStars) // render the falling stars at the mouse location
    {
      // end point (x,y) of star changes to make it look like the star is moving
       starDynamicEndX -= 5;
       starDynamicEndY += 5; 
  
      // draw falling stars
      stroke(neonBlue);
      line(starStaticStartX, starStaticStartY,  starDynamicEndX,  starDynamicEndY);
      fill(neonBlue);
      ellipse(starDynamicEndX, starDynamicEndY, 10, 10);
      stroke(neonOrange);
      line(starStaticStartX + 70, starStaticStartY + 70,  starDynamicEndX + 70,  starDynamicEndY + 70);
      fill(neonOrange);
      ellipse(starDynamicEndX + 70, starDynamicEndY + 70, 10, 10);
      stroke(neonPink);
      line(starStaticStartX + 140, starStaticStartY + 140,  starDynamicEndX + 140,  starDynamicEndY + 140);
      fill(neonPink);
      ellipse(starDynamicEndX + 140, starDynamicEndY + 140, 10, 10);
      stroke(neonGreen); 
      line(starStaticStartX + 210, starStaticStartY + 210,  starDynamicEndX + 210,  starDynamicEndY + 210);
      fill(neonGreen);
      ellipse(starDynamicEndX + 210, starDynamicEndY + 210, 10, 10);
  
      // check if falling stars reach bottom of the screen
      if (starDynamicEndY > 600) 
      {
        renderFallingStars = false;  // stop rendering the falling stars
      }
    }
}

// increase all existing planet sizes
void increaseEveryPlanetSize()
{
  for(Planet planet: solarSystem)
  {
      planet.widthPlanet += 1;
      planet.heightPlanet += 1;
      if(planet.type == "earth" || planet.type == "mars")
      {
        planet.moonOffset += 0.6;
      }
  }
}

// decrease all existing planet sizes
void decreaseEveryPlanetSize()
{
  for(Planet planet: solarSystem)
  {
      planet.widthPlanet -= 1;
      planet.heightPlanet -= 1;
      if(planet.type == "earth" || planet.type == "mars")
      {
        planet.moonOffset -= 0.6;
      }
  }
}

// left mouse click to increase all existing planet size and right mouse click to decrease all existing planet sizes
void mousePressed()
{
  if (mouseButton == RIGHT)
  {
    increaseEveryPlanetSize();
  }
  if (mouseButton == LEFT)
  {
     decreaseEveryPlanetSize();
  }
}

// check which Planet type the letter belongs to (each Planet type has their own alphabet set)
String checkLetter(char letter)
{
    String result = "";
    for(char a: earthLetters)
    {
        if (a == letter)
        {
            result = "earth";
            return result;
        }
    }
    for (char b: jupiterLetters)
    {
        if (b == letter)
        {
            result = "jupiter";
            return result;
        }
    }
    for (char c: saturnLetters)
    {
        if (c == letter)
        {
            result = "saturn";
            return result;
        }
    }
    result = "mars";
    return result;
}

// decrease radius of 1/4 exisitng Planet types when vowel is pressed
void decreaseRadius(String type)
{
    for(Planet planet : solarSystem)
    {
        if (planet.type == "earth" && type == "earth")
        {
            planet.orbitRadius -= radiusChange;
        }
        else if (planet.type == "jupiter" && type == "jupiter")
        {
            planet.orbitRadius -= radiusChange;
        }
        else if (planet.type == "saturn" && type == "saturn")
        {
            planet.orbitRadius -= radiusChange;
        }
        else if(planet.type == "mars" && type == "mars")
        {
            planet.orbitRadius -= radiusChange;
        }
    }
}

// increase radius of 1/4 exisitng Planet types when consonant is pressed
void increaseRadius(String type)
{
    for(Planet planet : solarSystem)
    {
        if (planet.type == "earth" && type == "earth")
        {
            planet.orbitRadius += radiusChange;
        }
        else if (planet.type == "jupiter" && type == "jupiter")
        {
            planet.orbitRadius += radiusChange;
        }
        else if (planet.type == "saturn" && type == "saturn")
        {
            planet.orbitRadius += radiusChange;
        }
        else if (planet.type == "mars" && type == "mars")
        {
            planet.orbitRadius += radiusChange;
        }
    }
}

void keyPressed() 
{
    print(key);
    if(key == '!')
    {
        Asteroid newPlanet = new Asteroid(planetPosition.x, planetPosition.y - 190);
        newPlanet.planetColor = neonYellow;
        solarSystem.add(newPlanet);
    }
    else if(key == ',')
    {
        Asteroid newPlanet = new Asteroid(planetPosition.x, planetPosition.y - 190);
        newPlanet.planetColor = neonRed;
        solarSystem.add(newPlanet);
    }
    else if(key == '.')
    {
        Asteroid newPlanet = new Asteroid(planetPosition.x, planetPosition.y - 190);
        newPlanet.planetColor = neonPurple;
        solarSystem.add(newPlanet);
    }
    else if(key == '?')
    {
      Asteroid newPlanet = new Asteroid(planetPosition.x, planetPosition.y - 190);
      newPlanet.planetColor = neonTeal;
      solarSystem.add(newPlanet);
    }
    else if(key == ' ') // save falling stars start location based on mouse location when spacebar is pressed
    {
      renderFallingStars = true;
      starStaticStartX = mouseX;
      starDynamicEndX = mouseX;
      starStaticStartY = mouseY;
      starDynamicEndY = mouseY;
    }
    else if(Character.isLetter(key)) // when a letter is pressed, add a Planet class type to the solarSystem array, and check if vowel or consonant to determine radius adjustments
    {
        key = Character.toLowerCase(key);
        if (checkLetter(key) == "earth")
        {
            Earth newPlanet = new Earth(planetPosition.x, planetPosition.y);
            if(key == 'a')
            {
                decreaseRadius("earth");
                newPlanet.orbitRadius -= radiusChange;
            }
            else
            {
                increaseRadius("earth");
                newPlanet.orbitRadius += radiusChange;
            }
            solarSystem.add(newPlanet);
        }
        else if(checkLetter(key) == "mars")
        {
            Mars newPlanet = new Mars(planetPosition.x, planetPosition.y - 43);
            if(key == 'e')
            {
                decreaseRadius("mars");
                newPlanet.orbitRadius -= radiusChange;
            }
            else
            {
                increaseRadius("mars");
                newPlanet.orbitRadius += radiusChange;
            }
            solarSystem.add(newPlanet);
        }
        else if(checkLetter(key) == "jupiter")
        {
            Jupiter newPlanet = new Jupiter(planetPosition.x, planetPosition.y - 85);
            if(key == 'y' || key == 'u')
            {
                decreaseRadius("jupiter");
                newPlanet.orbitRadius -= radiusChange;
            }
            else
            {
                increaseRadius("jupiter");
                newPlanet.orbitRadius += radiusChange;
            }
            solarSystem.add(newPlanet);
        }
        else if(checkLetter(key) == "saturn")
        {
            Saturn newPlanet = new Saturn(planetPosition.x, planetPosition.y - 135);
            if(key == 'i' || key == 'o')
            {
                decreaseRadius("saturn");
                newPlanet.orbitRadius -= radiusChange;
            }
            else
            {
                increaseRadius("saturn");
                newPlanet.orbitRadius += radiusChange;
            }
            solarSystem.add(newPlanet);
        }
    }
    else if(Character.isDigit(key)) // when a digit (1-8) is pressed, adjust the CW/CCW direction each orbit
    {
        if(key == '1')
        {
            earthCW = false;
        }
        else if(key == '2')
        {
            marsCW = false;
        }
        else if (key == '3')
        {
            jupiterCW = false;
        }
        else if(key == '4')
        {
           saturnCW = false;
        }
        else if(key == '5')
        {
            asteroidCW = false;
        }
        else if(key == '6')
        {
             earthCW = true;
        }
        else if(key == '7')
        {
             marsCW = true;
        }
        else if(key == '8')
        {
           jupiterCW = true;
        }
         else if(key == '9')
        {
            saturnCW = true;
        }
        else if(key == '0')
        {
           asteroidCW = true;
        }
    }
    else if ((keyCode == BACKSPACE || keyCode == DELETE) && solarSystem.size() > 0) // when delete or backspace is pressed, remove last Planet that was added to solar system array
    {
       solarSystem.remove(solarSystem.size() - 1);
    }
    else if (keyCode == ENTER)
    {
       solarSystem.clear();
       bigBang = true;
    }
}

// parent class Planet: has datamembers for the movement of each planet (orbit raidus and direction), and other characterstics such as size, color, moon offset, etc.
// child classes for each Planet type: Earth, Jupiter, Saturn, and Mars where each shape maps to letters. Asteroid is also a child class that maps color to punctuation.
class Planet
{
    PVector coordinate; // (x,y) coordinate of the Planet
    int planetColor; // color of the Planet
    float angle = 0; // angle for dynamic circular path/orbit of Planet
    String type;    // type of Planet
    float orbitRadius; // radius of circular path that each Planet travels along
    float widthPlanet = 18.0;
    float heightPlanet = 18.0;
    float curveLength = 375; // length of the curve behind planet (creates orbit using length of curve)
    ArrayList<PVector> orbitCoordinates = new ArrayList<PVector>(); // coordinates for curve that follows planet to become orbit/circle
    float moonOffset = 10;

    Planet(float x, float y, int planetColor, String type, float orbitRadius) 
    {
      coordinate = new PVector(x, y); // initialize the position
      this.planetColor = planetColor; // set the color
      this.type = type; // set the id/planet type
      this.orbitRadius = orbitRadius; // set the planet orbit radius
    }
  /**
   updates circular direction of Planets during a circular path/orbit (CW or CCW):
   update x-coordinate in pixels using cos(angle) * orbitRadius to update horizontal displacement
   update y-coordinate in pixels using sin(angle) * orbitRadius to update vertical displacement
   updates angle from center point of circle; required in radians for trig functions
   **/
  void updateCW()
  {
      angle += radians(1);
      coordinate.x = coordinate.x + cos(angle) * orbitRadius;
      coordinate.y = coordinate.y + sin(angle) * orbitRadius;
  }
  void updateCCW()
  {
      angle -= radians(1);
      coordinate.x = coordinate.x - cos(angle) * orbitRadius;
      coordinate.y = coordinate.y - sin(angle) * orbitRadius;
  }
  void render(){}
}

class Earth extends Planet
{
  Earth(float x, float y)
  {
    super(x, y, neonOrange, "earth", 1);
  }
  void render()
  {
      // calculate the updated coordinate along the circular path
      float updatedX = coordinate.x + cos(angle) * orbitRadius; 
      float updatedY = coordinate.y + sin(angle) * orbitRadius;
      orbitCoordinates.add(new PVector(updatedX, updatedY));  // store the updated coordinate to be used in curve behind planet
      if (orbitCoordinates.size() > curveLength)         // custom length of curve by setting the length of the curve to create an orbit
          orbitCoordinates.remove(0);
  
      // render curve along stored coordinates
      stroke(neonOrange);
      noFill();
      beginShape();
      for (PVector orbitCoordinate : orbitCoordinates)
          vertex(orbitCoordinate.x, orbitCoordinate.y);
      endShape();
  
      // render Earth at the current (x,y)
      noStroke();
      fill(planetColor);
      ellipse(coordinate.x, coordinate.y, widthPlanet, heightPlanet);
      
      // render moon for Earth
      ellipse(coordinate.x + moonOffset , coordinate.y - moonOffset, widthPlanet/2, heightPlanet/2);
  }
}
class Mars extends Planet
{
  Mars(float x, float y)
  {
      super(x, y, neonPink, "mars", 1.8);
  }
  void render()
  {
      // calculate the updated coordinate along the circular path
      float updatedX = coordinate.x + cos(angle) * orbitRadius;      
      float updatedY = coordinate.y + sin(angle) * orbitRadius;
      orbitCoordinates.add(new PVector(updatedX, updatedY));  // store the updated coordinate to be used in rendering curve/orbit
      if (curveLength < orbitCoordinates.size())         // custom length of curve by setting the curveLength to create orbit
          orbitCoordinates.remove(0);
  
      // render curve along stored coordinates
      stroke(neonPink);
      noFill();
      beginShape();
      for (PVector orbitCoordinate : orbitCoordinates)
          vertex(orbitCoordinate.x, orbitCoordinate.y);
      endShape();
  
      // render planet at the current (x,y)
      noStroke();
      fill(planetColor);
      ellipse(coordinate.x, coordinate.y, widthPlanet, heightPlanet);
      
      // render moons for Mars
      ellipse(coordinate.x + moonOffset , coordinate.y - moonOffset, widthPlanet/2, heightPlanet/2);
      ellipse(coordinate.x - moonOffset , coordinate.y + moonOffset, widthPlanet/2, heightPlanet/2);
      
  }
}
class Jupiter extends Planet
{
  Jupiter(float x, float y)
  {
      super(x, y, neonBlue, "jupiter", 2.6);
  }

  void render()
  {
      // calculate the updated coordinate along the circular path
      float updatedX = coordinate.x + cos(angle) * orbitRadius;  
      float updatedY = coordinate.y + sin(angle) * orbitRadius;
      orbitCoordinates.add(new PVector(updatedX, updatedY));  // store the updated coordinate to be used in rendering curve/orbit
      if (orbitCoordinates.size() > curveLength)         // custom length of curve by setting the curveLength to create orbit
          orbitCoordinates.remove(0);
  
      // render curve along stored coordinates
      stroke(neonBlue);
      noFill();
      beginShape();
      for (PVector orbitCoordinate : orbitCoordinates)
          vertex(orbitCoordinate.x, orbitCoordinate.y);
      endShape();
  
      // render planet at the current (x,y)
      noStroke();
      fill(planetColor);
      ellipse(coordinate.x, coordinate.y, widthPlanet, heightPlanet);
      
      noFill();
      stroke(planetColor);
      strokeWeight(2);
      ellipse(coordinate.x, coordinate.y, widthPlanet * 2.0, heightPlanet * 0.5);
  }
}
class Saturn extends Planet
{
  Saturn(float x, float y)
  {
      super(x, y, neonGreen, "saturn", 3.4);
  }
  void render()
  {
    // calculate the updated coordinate along the circular path
    float updatedX = coordinate.x + cos(angle) * orbitRadius;
    float updatedY = coordinate.y + sin(angle) * orbitRadius;
    orbitCoordinates.add(new PVector(updatedX, updatedY));  // store the updated coordinate for to be used in curve
    if (orbitCoordinates.size() > curveLength)         // custom length of curve by setting the curveLength to create orbit
        orbitCoordinates.remove(0);
  
    // render curve along stored coordinates
    stroke(neonGreen);
    noFill();
    beginShape();
    for (PVector orbitCoordinate : orbitCoordinates)
        vertex(orbitCoordinate.x, orbitCoordinate.y);
    endShape();
  
    // render planet at the current (x,y)
    noStroke();
    fill(planetColor);
    ellipse(coordinate.x, coordinate.y, widthPlanet, heightPlanet);
    
    // render rings using outline of ellipses
    noFill();
    stroke(planetColor);
    strokeWeight(2);
    ellipse(coordinate.x, coordinate.y, widthPlanet * 2.0, heightPlanet * 0.5);
    ellipse(coordinate.x, coordinate.y, widthPlanet * 3.0, heightPlanet * 0.5);
    ellipse(coordinate.x, coordinate.y, widthPlanet * 4.0, heightPlanet * 0.5);
  }
}

// child class for Asteroid type which maps to punctuation
class Asteroid extends Planet
{
   Asteroid(float x, float y)
  {
      super(x, y, neonGreen, "asteroid", 4.2);
  }
  void render()
  {
      // render Asteroid for punctuation
      noStroke();
      fill(planetColor);
      ellipse(coordinate.x, coordinate.y, widthPlanet, heightPlanet);
  }
}
