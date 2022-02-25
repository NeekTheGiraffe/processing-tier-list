import java.lang.StringBuilder;

public class TierItem {
  
  public static final int LENGTH = 100;
  
  private final PImage img;
  
  private float x, y;
  private int _brightness, _alpha;
  
  public TierItem(float x, float y, PImage img) {
    this.x = x;
    this.y = y;
    this.img = img;
    _brightness = 255;
    _alpha = 255;
    
    this.img.resize(LENGTH, LENGTH);
  }
  public TierItem(float x, float y, PImage img, int brightness, int alpha) {
    this.x = x;
    this.y = y;
    this.img = img;
    _brightness = brightness;
    _alpha = alpha;
    
    this.img.resize(LENGTH, LENGTH);
  }
  public TierItem(TierItem other) {
    x = other.x;
    y = other.y;
    img = other.img;
    _brightness = other._brightness;
    _alpha = other._alpha;
  }
  
  // Returns or sets the x or y coordinates of this TierItem.
  public float x() { return x; }
  public void setX(float x) { this.x = x; }
  public float y() { return y; }
  public void setY(float y) { this.y = y; }
  public void setPosition(float x, float y) { this.x = x; this.y = y; }
  public int brightness() { return _brightness; }
  public void setBrightness(int b) { _brightness = b; }
  public int alpha() { return _alpha; }
  public void setAlpha(int a) { _alpha = a; }
  
  // Returns if the point specified by x, y is inside this TierItem.
  public boolean contains(float x, float y) {
    if (x < this.x || x > this.x + LENGTH) return false;
    if (y < this.y || y > this.y + LENGTH) return false;
    return true;
  }
  
  // Displays this TierItem
  public void display() {
    tint(_brightness, _alpha);
    image(img, x, y);
  }
  
  @Override
  public String toString() {
    StringBuilder bld = new StringBuilder();
    bld.append("TierItem{x=").append(x).append(", y=").append(y).append('}');
    return bld.toString();
  }
}
