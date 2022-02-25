import java.util.List;
import java.util.ArrayList;
import java.io.File;

final int WIDTH = 1000;

String path = "C:/Users/npavl/Documents/Development/processing/resources/professors";
File imageDir = new File(path);
String[] imageList = imageDir.list();

PFont f;
TierList tierList;
MouseHandler mouseHandler;

void settings() {
  size(WIDTH, 1000);
}

void setup() {
  f = createFont("Arial", 16, true);
  textFont(f, 36);
  
  surface.setTitle("Tier List Maker");
  surface.setResizable(true);
  
  tierList = new TierList(Tier.MARGIN, Tier.MARGIN, WIDTH - 2f * Tier.MARGIN);
  mouseHandler = new MouseHandler(tierList);
  
  for (String imageName : imageList) {
    tierList.add(loadImage(path + "/" + imageName));
  }
}

void draw() {
  
  // Change height, but only if necessary
  float ht = tierList.height() + 2f * Tier.MARGIN;  
  if (height != ht) surface.setSize(WIDTH, (int)ht);
  
  mouseHandler.handleMouseMoved(mouseX, mouseY);
  
  background(200);
  tierList.display();
  mouseHandler.display();
}

void mouseDragged() {
  mouseHandler.handleMouseDragged(mouseX, mouseY);
}

void mouseReleased() {
  mouseHandler.handleMouseReleased(mouseX, mouseY);
}
