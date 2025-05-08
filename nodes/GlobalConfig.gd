extends Node2D

var COL = 10;
var ROW = 6;

var BLOCK_SIZE = 64;
var TOP_BOUNDARY = BLOCK_SIZE; #for the boundary of the top of the grid
var BOTTOM_BOUNDARY = BLOCK_SIZE * (COL + 1); #for the boundary of the bottom of the grid
var LEFT_BOUNDARY = BLOCK_SIZE; #for the boundary of the left of the grid
var RIGHT_BOUNDARY = BLOCK_SIZE * (ROW + 1); #for the boundary of the right of the grid