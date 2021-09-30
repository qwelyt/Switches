$fn=30;

module ooo(r=1){
  offset(r)offset(-r*2)offset(r)children();
}

module opener(h){
  r=1;
  module frame(){
    difference(){
      linear_extrude(h)ooo()square([16,16],center=true);
      translate([0,0,-1])linear_extrude(h*2)ooo()square([14,12],center=true);
    }
  }
  module peg(hp){
    hull(){
      translate([0,1.4/2-0.01/2,hp])cube([2,0.01,0.1],center=true);
      translate([0,0,hp-2])cube([2,1.5,0.1],center=true);
      translate([0,-0.25,-0.5])cube([2,2,0.1],center=true);
    }
  }
  
  module peg2(hp,w=2.5){
    translate([-w/2,-2/2,hp/2])
    rotate([0,90,0])
    linear_extrude(w)
    hull(){
      square([0.1,0.1],center=true);
      translate([hp-2,1.5,0])square([0.1,0.1],center=true);
      translate([hp,0,0])square([0.1,0.1],center=true);
      translate([hp,1.9,0])square([0.1,0.1],center=true);
    }
  }
  module pegs(){
    translate([0,7.05,h+2.2]){
      translate([3.25,0])peg2(3.5);
      translate([-3.25,0])peg2(3.5);
    }
    translate([0,-7,h])cube([10,2,1],center=true);
    translate([5,-7,h-0.21])rotate([0,45,0])cube([1,2,1],center=true);
    translate([-5,-7,h-0.21])rotate([0,45,0])cube([1,2,1],center=true);
  }
//  peg(3.5);
//  translate([3,0,0])peg2(3.5);
  pegs();
  mirror([0,1,0])pegs();
  frame();
}


//translate([0,0,4])color([1,0.3,0.9])import("choc.stl");

h=6;
//translate([0,0,-h/2])
opener(h=h);