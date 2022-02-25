public class MouseHandler {
  
  private TierItem dragged;
  private TierItem ghostDragged;
  private TierList tierList;
  
  private TierItem prev;
  
  public MouseHandler(TierList tl) { tierList = tl; }
  
  public void handleMouseDragged(float x, float y) {
    
    if (dragged == null) {
      
      dragged = tierList.get(x, y);
      if (dragged == null) return;
      
      dragged.setBrightness(100);
      
      ghostDragged = new TierItem(dragged);
      ghostDragged.setBrightness(255);
      ghostDragged.setAlpha(127);
      
      // Replace the selected item with the ghost item
      // This incidentally "removes" the original item from the tier 
      tierList.set(x, y, ghostDragged);
      
      tierList.setShrink(false);
      
      return;
    }
    
    // Dragged already exists
    
    // Set the position of dragged so that the mouse is over
    // the center of the image
    dragged.setPosition(x - 0.5*TierItem.LENGTH, y - 0.5*TierItem.LENGTH);
    
    // Adjust the container
    tierList.adjust(ghostDragged, x, y);
  }
  
  public void handleMouseReleased(float x, float y) {
    
    if (dragged == null) return;
    
    tierList.set(ghostDragged, dragged); // Replace the ghost item with the real item
    dragged.setBrightness(255);
    dragged = null;
    ghostDragged = null;
    
    tierList.setShrink(true);
  }
  
  public void handleMouseMoved(float x, float y)
  {
    TierItem current = tierList.get(x, y);
    
    //println("current=" + current + ", prev=" + prev);
    
    if (dragged == null) {
      if (current != null) {
        int b = (mousePressed) ? 100 : 150;
        //println("brightness=" + b);
        current.setBrightness(b);
      }
      if (prev != null && current != prev) {
        prev.setBrightness(255);
      }
    }
    
    prev = current;
  }
  
  public void display() {
    if (dragged != null) {
      dragged.display();
    }
  }
}
