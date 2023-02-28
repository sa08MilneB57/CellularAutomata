
interface IntegerColorMap{
  color map(int i);
}

class AbsoluteValueWrapper implements IntegerColorMap{
  private IntegerColorMap cmap;
  AbsoluteValueWrapper(IntegerColorMap _cmap){cmap=_cmap;}
  color map(int i){return cmap.map(abs(i));}
  
}

class AlphaIgnoreWrapper implements IntegerColorMap{
  private IntegerColorMap cmap;
  AlphaIgnoreWrapper(IntegerColorMap _cmap){cmap=_cmap;}
  color map(int i){
    color c = cmap.map(i);
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    return color(r,g,b);
  }
  
}


class NullColorMap implements IntegerColorMap{
  color map(int i){return i;}
}


class BinaryColorMap implements IntegerColorMap{
  color off,on;
  BinaryColorMap(){off = color(255);on = color(0);}
  BinaryColorMap(color zero,color one){off = zero; on = one;}
  color map(int i){
    if(!(i==0||i==1)){throw new IllegalArgumentException("This colormap expects values of 0 or 1 and received: " + i);}
    return (i==1)?on:off;
  }
  
}

class RedBlueMap implements IntegerColorMap{
  int maxn;
  RedBlueMap(int _maxn){maxn=_maxn;}
  
  color map(int i){
    if (i>=0){
      return color(255*((float)i/maxn),100*((float)i/maxn),0);
    } else {
      return color(0,-100*((float)i/maxn),-255*((float)i/maxn));
    }
  }
}


class LerpRGBMap implements IntegerColorMap{
  int maxn;
  color c1,c2;
  Integer maxCol;
  LerpRGBMap(int _maxn, color _c1, color _c2,Integer _maxCol){
    maxn = _maxn;
    maxCol = _maxCol;
    c1 = _c1;
    c2 = _c2;
  }
  color map(int i){
    if(i>maxn && maxCol != null){return maxCol;}
    return lerpColor(c1,c2,(float)i/maxn);
  } 
  
}

class LerpHSLMap implements IntegerColorMap{
  int maxn;
  Integer maxCol;
  color[] LUT;
  LerpHSLMap(int _maxn, color c1, color c2,Integer _maxCol){
    maxn = _maxn;
    maxCol = _maxCol;
    float[] hsl1 = inverseHSL(c1);
    float[] hsl2 = inverseHSL(c2);
    float delta = hsl2[0] - hsl1[0];
    if (delta > PI){
      hsl2[0] = hsl2[0] - TAU;
    } else if (delta < -PI){
      hsl2[0] = hsl2[0] + TAU;
    }
    float alpha1 = alpha(c1)/255f;
    float alpha2 = alpha(c2)/255f;
    LUT = new color[maxn+1];
    for (int i=0; i<=maxn; i++){
      float t = (float)i/maxn;
      float H = lerp(hsl1[0],hsl2[0],t);
      float S = lerp(hsl1[1],hsl2[1],t);
      float L = lerp(hsl1[2],hsl2[2],t);
      float A = lerp(alpha1,alpha2,t);
      LUT[i] = HSL(H,S,L,A);
    }
    
  }
  color map(int i){
    if(i>maxn && maxCol != null){return maxCol;}
    i = min(i,maxn -1);
    i = max(i,0);
    return LUT[i];
  }
  
}

class LerpYCoCgMap implements IntegerColorMap{
  //Technically not a lerp, lerps magnitude of (Co,Cg) vector and angle seperately
  int maxn;
  Integer maxCol;
  color[] LUT;
  LerpYCoCgMap(int _maxn, color c1, color c2,Integer _maxCol){
    maxn = _maxn;
    maxCol = _maxCol;
    float[] YCoCg1 = inverseYCoCg(c1);
    float[] YCoCg2 = inverseYCoCg(c2);
    float chromaMag1 = sqrt(YCoCg1[1]*YCoCg1[1] + YCoCg1[2]*YCoCg1[2]);
    float chromaMag2 = sqrt(YCoCg2[1]*YCoCg2[1] + YCoCg2[2]*YCoCg2[2]);
    float chromaTheta1 = atan2(YCoCg1[2],YCoCg1[1]);
    float chromaTheta2 = atan2(YCoCg2[2],YCoCg2[1]);
    float deltaTheta = chromaTheta2 - chromaTheta1;
    if (deltaTheta > PI){
      chromaTheta2 -= TAU;
    } else if (deltaTheta < -PI){
      chromaTheta2 += + TAU;
    }
    float alpha1 = alpha(c1)/255f;
    float alpha2 = alpha(c2)/255f;
    LUT = new color[maxn+1];
    for (int i=0; i<=maxn; i++){
      float  t = (float)i/maxn;
      float chroMag = lerp(chromaMag1,chromaMag2,t);
      float chromaTheta = lerp(chromaTheta1,chromaTheta2,t);
      float  Y = lerp(YCoCg1[0],YCoCg2[0],t);
      float Co = chroMag * cos(chromaTheta);
      float Cg = chroMag * sin(chromaTheta);
      float  A = lerp(alpha1,alpha2,t);
      LUT[i] = YCoCg(Y,Co,Cg,A);
    }
    
  }
  color map(int i){ 
    if(i>maxn && maxCol != null){return maxCol;}
    i = min(i,maxn -1);
    i = max(i,0);
    return LUT[i];
  }
  
}


class GradientFromFile implements IntegerColorMap{
  private color[] LUT;
  private float scaleFactor;
  private int maxn;
  GradientFromFile(String name,int _maxn){
    maxn = _maxn;
    String filename = "gradients/" + name + ".tga";
    PImage img = loadImage(filename);
    if(img == null || img.width == -1){throw new RuntimeException("Could not load the image at '" + filename + "'");}
    if(img.height != 1){throw new IllegalArgumentException("Gradient image at '" + filename + "' must have a height of 1 pixel.");}
    scaleFactor = (float)img.width/(float)maxn;
    LUT = new color[img.width];
    img.loadPixels();
    arrayCopy(img.pixels,LUT);
    img.updatePixels();
  }
  
  color map(int i){
    i = min(i,maxn -1);
    i = max(i,0);
    return LUT[(int)(i*scaleFactor)];
  }
  
}

class RainbowMap implements IntegerColorMap{
  int n;
  RainbowMap(int _n){n=_n;}
  color map(int i){return HSL(TAU*i/n,1f,0.5);}
  color absmap(int i){return map(abs(i));}
}

class WireWorldColorMap implements IntegerColorMap{
  color map(int i){
    switch(i){
      case 0: //EMPTY
        return color(0);
      case 1: //ELECTRON HEAD
        return color(255,100,100);
      case 2: //ELECTRON TAIL
        return color(255,255,50);
      case 3: //CONDUCTOR
        return color(20,100,20);
      default: //ERROR
        return color(255,0,255);
    }
  }
}

class SandpileColorMap implements IntegerColorMap{
  color map(int i){
    switch(i){
      case 0:
        return color(0);
      case 1:
        return color(0,180,0);
      case 2:
        return color(150,20,150);
      case 3:
        return color(255,255,0);
      //case 4:
      //  return color(200,0,0);
      //case 5:
      //  return color(0,0,200);
      //case 6:
      //  return color(0,100,100);
      //case 7:
      default:
        return color(255);
    }
  }
}
