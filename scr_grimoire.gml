// If you have any questions, improvements, or requests, let's talk!

#region Input Helpers and Definitions

#macro PRAGMA_FORCE_INLINE gml_pragma("forceinline")

#region INDEX MACROS

#macro OBJECT_INDEX_CEILING 100_000

#endregion

#region VIRTUAL KEY DEFS

//Letters
#macro vk_a ord("A")
#macro vk_b ord("B")
#macro vk_c ord("C")
#macro vk_d ord("D")
#macro vk_e ord("E")
#macro vk_f ord("F")
#macro vk_g ord("G")
#macro vk_h ord("H")
#macro vk_i ord("I")
#macro vk_j ord("J")
#macro vk_k ord("K")
#macro vk_l ord("L")
#macro vk_m ord("M")
#macro vk_n ord("N")
#macro vk_o ord("O")
#macro vk_p ord("P")
#macro vk_q ord("Q")
#macro vk_r ord("R")
#macro vk_s ord("S")
#macro vk_t ord("T")
#macro vk_u ord("U")
#macro vk_v ord("V")
#macro vk_w ord("W")
#macro vk_x ord("X")
#macro vk_y ord("Y")
#macro vk_z ord("Z")
//Digits
#macro vk_1 ord("1")
#macro vk_2 ord("2")
#macro vk_3 ord("3")
#macro vk_4 ord("4")
#macro vk_5 ord("5")
#macro vk_6 ord("6")
#macro vk_7 ord("7")
#macro vk_8 ord("8")
#macro vk_9 ord("9")
#macro vk_0 ord("0")
//Punctuation
#macro vk_colon 186
#macro vk_tilde 192

#macro CHAR_TILDE 192
#macro CHAR_NEWLINE chr(10)

#endregion

#region INPUT HELPERS
#macro kb keyboard_check
#macro kb_p keyboard_check_pressed
#macro kb_r keyboard_check_released

#macro gp gamepad_button_check
#macro gp_p gamepad_button_check_pressed
#macro gp_r gamepad_button_check_released

#macro mb_p mouse_check_button_pressed
#macro mb_r mouse_check_button_released
#macro mb mouse_check_button
#endregion


#endregion
#region Display Helpers
// Display macros
#macro display_width display_get_width()
#macro display_height display_get_height()
#macro display_center_x (display_get_width()/2)
#macro display_center_y (display_get_height/2)

#macro window_width window_get_width()
#macro window_height window_get_height()
#macro gui_width display_get_gui_width()
#macro gui_height display_get_gui_height()
#endregion
#region Logging Macros
#macro log show_debug_message
#macro debuglog show_debug_message
#macro SHOW show_message
#macro RELEASE:SHOW show_debug_message
#macro ERROR show_error
#macro LOG_W show_debug_message
#macro RELEASE:LOG_W show_debug_message
#macro LOG_I show_debug_message

#endregion 

#region SHARED DATA STRUCTURES
ds_list_create();
#macro LIST 0

#endregion

#region TIME

#macro SECONDS_TO_MILLISECONDS 1000

function timer(_seconds,_callback,_args=[]){
	//TODO: Since these aren't tied to a time_source, they can't be paused.  wtf to do.
	//https://trello.com/c/dhdZmE0B/281-todo-timers-cant-be-tied-to-a-time-source-now-what-do
	return call_later(_seconds,time_source_units_seconds,_callback);
	//__i = time_source_create(time_source_game,_seconds,time_source_units_seconds,_callback,_args);
	//time_source_start(__i);
	//return __i;
}

#endregion

#region sprites

#region IMAGES
///@desc Stops animation where it is.
function image_freeze(){
	image_speed=0;	
}

///@desc stops the sprite animation next time the loop finishes.
function image_finish(){
	if (image_index>=image_number-image_speed){image_speed=0; image_index=image_number-1;  return true;}
	return false;
}

///@desc stops the sprite animation at first image;
function image_end(){
	if (image_index>=image_number-1){image_speed=0; image_index=0;  return true;}
	return false;
}


function image_even(){
	return ((floor(image_index) mod 2)==0)	
}

function image_single(_image=0){
	image_index=_image;
	image_speed=0;
}

#endregion

///@desc Changes sprite without changing image_index (like for changing facing during walk anims)
function sprite_shift(_sprite,_image_speed=image_speed){
	sprite_index=_sprite;
	image_speed=_image_speed;
}

///@desc Changes sprite and resets image index
function sprite_change(_sprite,_image_speed = image_speed){
	image_speed=_image_speed;
	if (sprite_index!=_sprite){sprite_index=_sprite; image_index=0; return true;}
	return false;
}

function fourway(__fac,__spr1,__spr2,__spr3){
	//var __fac = (round(direction/90)) mod 4
	switch (__fac mod 4){
		case 0:
			mirror=1;
			return __spr1;
		break;
	
		case 1:
			return __spr2;
		break;
	
		case 2:
			mirror=-1;
			return __spr1;
		break;
	
		case 3:
			return __spr3;
		break;
	}
}
///@function draw_stacked_sprite_ext
///@param sprite_index
///@param x
///@param y
///@param z
///@param image_xscale
///@param image_yscale
///@param image_zscale
///@param image_angle
///@param image_blend
function draw_stacked_sprite_ext() {

	var _sprite_index = argument[0];
	var _x				= argument[1];
	var _y				= argument[2];
	var _z				= argument[3];
	var _image_xscale	= argument[4];
	var _image_yscale	= argument[5];
	var _image_zscale	= argument[6];
	var _image_angle	= argument[7];
	//var image_alpha //making alpha work with sprite stacking is out of scope of this tutorial

	_image_zscale *= 1//oCamera.image_zscale;

	// compute the amount we move each layer by
	// default direction is up (90*), and from there we want the opposite of the camera angle
	var _x_step = 0//oCamera.x_step * _image_zscale;
	var _y_step = 1//oCamera.y_step * _image_zscale;
	var _z_step = 1//oCamera.z_step;
	var _z_height = sprite_get_number(_sprite_index);

	// loop through each slice of the sprite, moving by x and y step each time
	for (var i = 0; i < _z_height; i += _z_step) {
		draw_sprite_ext(_sprite_index, i, _x - _x_step * (i+_z), _y - _y_step * (i+_z), _image_xscale, _image_yscale, _image_angle,image_blend, 1.0);
	}


}


#endregion

#region masks/bounding boxes

function bbox_width(){
	return abs(bbox_right - bbox_left)	
}

function bbox_height(){
	return abs(bbox_bottom - bbox_top)	
}

#endregion

#region camera
///@param camera
function get_view_center_x(_arg0){
	var cam = view_get_camera(_arg0);
	var left = camera_get_view_x(cam);
	var w = camera_get_view_width(cam);
	return left + w/2;
}

///@param camera
function get_view_center_y(_arg0){
	var cam = view_get_camera(_arg0);
	var top = camera_get_view_y(cam);
	var h = camera_get_view_height(cam);
	return top + h/2;
}

function view_bottom(_view){
	var cam = view_get_camera(_view);
	var top = camera_get_view_y(cam);
	var h = camera_get_view_height(cam);
	return top+h;
}

function view_top(_view){
	var cam = view_get_camera(_view);
	var top = camera_get_view_y(cam);
	return top;
}

function view_right(_view){
	var cam = view_get_camera(_view)
	return (camera_get_view_x(cam)+camera_get_view_width(cam));
}

function view_left(_view){
	var cam = view_get_camera(_view)
	return (camera_get_view_x(cam));
}

#endregion

#region STRINGS
///@param StringToBeSplit
///@param delimiter
function splitString(){
	var str = _arg0; //string to split
	var delimiter = _arg1; //string to split the first string by
	var slot = 0;
	var strings=undefined; //array to hold all strings we have split
	var workingStr = ""; //uses a working array to hold the delimited data we're currently looking at
	
	for (var i = 1; i < (string_length(str)+1); i++) {
	    var currStr = string_copy(str, i, 1);
	    if (currStr == delimiter) {
	        strings[slot] = workingStr; //add this split to the array of all strings
	        slot++;
	        workingStr = "";
	    } else {
	        workingStr = workingStr + currStr;
	        strings[slot] = workingStr;
	    }
	}
	return strings;
}

/// @function                   string_wrap(text, width);
/// @param  {string}    text    The text to wrap
/// @param  {real}      width   The maximum width of the text before a line break is inserted
/// @description        Take a string and add line breaks so that it doesn't overflow the maximum width
function string_wrap(_text, _width)
{
var _text_wrapped = "";
var _space = -1;
var _char_pos = 1;
while (string_length(_text) >= _char_pos)
    {
    if (string_width(string_copy(_text, 1, _char_pos)) > _width)
        {
        if (_space != -1)
            {
            _text_wrapped += string_copy(_text, 1, _space) + "\n";
            _text = string_copy(_text, _space + 1, string_length(_text) - (_space));
            _char_pos = 1;
            _space = -1;
            }
        }
    if (string_char_at(_text,_char_pos) == " ")
        {
        _space = _char_pos;
        }
    _char_pos += 1;
    }
if (string_length(_text) > 0)
    {
    _text_wrapped += _text;
    }
return _text_wrapped;
}

/// @function                   string_wrap(text, width);
/// @param  {string}    text    The text to wrap
/// @param  {real}      width   The character limit before it wraps
/// @description        Take a string and add line breaks so that it doesn't overflow the maximum width
function string_wrap_charcount(_text, _char_max)
{
var _text_wrapped = "";
var _space = -1;
var _char_pos = 1;
var _line_width = 1;

while (string_length(_text) >= _char_pos)
    {
    if (_char_pos > _char_max)
        {
		//If we know where a space is
        if (_space != -1)
            {
			//Wrap to next line
            _text_wrapped += string_copy(_text, 1, _space) + "\n";
            _text = string_copy(_text, _space + 1, string_length(_text) - (_space));
            _char_pos = 1;
            _space = -1;
            }
        }
		//Update that we found a space!
    if (string_char_at(_text,_char_pos) == " ")
        {
        _space = _char_pos;
        }
	//Advance cursor
    _char_pos += 1;
    }
	//
if (string_length(_text) > 0)
    {
    _text_wrapped += _text;
    }
return _text_wrapped;
}

#endregion

#region Math

//map a value from one range to another
function map_value(_value, _current_lower_bound, _current_upper_bound, _desired_lowered_bound, _desired_upper_bound) {
	return (((_value - _current_lower_bound) / (_current_upper_bound - _current_lower_bound)) * (_desired_upper_bound - _desired_lowered_bound)) + _desired_lowered_bound;
}

function modulo(_a, _b) {
	return (((_a % _b) + _b) % _b);
}
///@desc irandom_range, but exclusive.
function irandom_between(_x,_y){
	if (_x + 1 > _y-1){show_error("irandom between can't work, no exclusive range possibile",true);}
	return irandom_range(_x+1,_y-1);	
}

function is_whole(_n){
	return  (round(_n) == _n);	
}

function is_even(_n){
	if !is_whole(_n) {show_error("is_even:  "+string(_n)+" is not a whole number.",false);}
	return ((_n % 2) > 0)
}
function is_odd(_n){
	return !is_even(_n);
}

function approach(_a,_b,_amount){

	if (_a< _b)
	{
	    _a+= _amount;
	    if (_a> _b)
	        return _b;
	}
	else
	{
	    _a-= _amount;
	    if (_a< _b)
	        return _b;
	}
	return _a;	
}

///@param 
/**
This is a bit funny to use.  Provide a value, then a weight, ad infinitum
For example:
weightedMean(x,0.1,y,0.9)
There must be an even number of arguments, or it will freak out.
The weights don't necessarily need to add up to 1.
**/
function weighted_mean(){
		var valueSum=0;
		var weightSum=0;
		
		for (var i=0;i<argument_count;i=i+2){
			var weight = argument[i+1];
			var value = argument[i];
			valueSum += value * weight;
			weightSum += weight;
		}
		
		//
		return valueSum/weightSum;
}

///@description Rounds given value to the nearest indicated denomination
///@param valueToBeRounded
///@param toNearestWhat
/// roundToNearest(0.83,0.05) == 0.85;
function roundToNearest(){
	return round(_arg0 / _arg1) * _arg1;
}


function angle_get_xcomponent(_angle){
	var _x = lengthdir_x(1,_angle);
	return (sign(_x))
}

function angle_get_ycomponent(_angle){
	var _y = lengthdir_y(1,_angle);
	return (sign(_y))
}

function angle_reflect_x(_angle){
	var _x = angle_get_xcomponent(_angle);
	var _y = angle_get_ycomponent(_angle)
	_x *= -1;
	return point_direction(0,0,_x,_y)
}

function angle_reflect_y(_angle){
	var _x = angle_get_xcomponent(_angle);
	var _y = angle_get_ycomponent(_angle)
	_y *= -1;
	return point_direction(0,0,_x,_y)
}


function angle_between(_angle,_angle1,_angle2){
		
}


function instance_direction(_id){
	return (point_direction(x,y,_id.x,_id.y));
}

#endregion

#region Probability

///@description Has a 1 in N chance to return true.  N of 0 is always false, N of 1 is always true.
///@param chance
function chance(_arg0){
	return (1==ceil(random(_arg0)))
}

///@description Rolls a d(n).  Returns a value between 1 and n.
///@param chance
function roll(_arg0){
	return (ceil(random(_arg0)))
}

#endregion

#region Procgen
function get_bresenham_points(_start_x, _start_y, _end_x, _end_y){
	
	var __delta_col = abs(_end_x - _start_x)
	var __delta_row = abs(_end_y - _start_y)
	var __point_x = _start_x
	var __point_y = _start_y
	var __horizontal_step = (_start_x < _end_x)
							?  1 
							: -1
	var __vertical_step = (_start_y < _end_y)
						  ?  1
						  : -1
	var __points = []
	var __difference = __delta_col - __delta_row
	while(true){
		
		var __double_difference = 2* __difference
		if(__double_difference > -__delta_row){
			__difference-=__delta_row;
			__point_x += __horizontal_step
		}
		if(__double_difference < __delta_col){
			__difference+=__delta_col;
			__point_y += __vertical_step
		}
		if((__point_x==_end_x)&&(__point_y==_end_y)){
			break;
		}
		array_push(__points,{x:__point_x, y:__point_y})
	}
	return __points;
}
///@desc Returns a DS list of Poisson Disk distributed points within a given circle radius.
function poisson_circle(_x,_y,_radius,_cellSize,_points_needed){

    //Using Generic Dart-Throwing right now;
    var _max_rejections = _points_needed*1000;
    var ls_points = ds_list_create();
    
    //Max rejections;
    for (var i=0;i<_max_rejections;i++){
        
        
		var __dir = random(360);
		var __len = random(_cellSize);
		
		var xx= (_x + lengthdir_x(__len,__dir));
        var yy= (_y + lengthdir_y(__len,__dir));

        var _valid = true;
        //Test to see if it is too close to existing points
        for (var _test=0;_test<ds_list_size(ls_points);_test++){
            var _test_node = ds_list_find_value(ls_points,_test);
            if (point_distance(xx,yy,_test_node.x,_test_node.y)<=_cellSize){
                //This doesn't work, we want to fail out of this inner for loop.
                _valid = false; 
				_test = infinity;
            }
        }
        if (_valid) {ds_list_add(ls_points,new vec2(xx,yy))}
        if (ds_list_size(ls_points)>=_points_needed){i=infinity;}
    }

    return ls_points;

}

///@desc Returns a DS list of Poisson Disk distributed points within a given rectangle.
function poisson_rectangle(_x,_y,_width,_height,_cellSize,_points_needed){

    //Using Generic Dart-Throwing right now;
    var _max_rejections = _points_needed*1000;
    var ls_points = ds_list_create();
    
    //Max rejections;
    for (var i=0;i<_max_rejections;i++){
        
        var xx= (_x + random(_width));
        var yy= (_y + random(_height));
        var _valid = true;
        //Test to see if it is too close to existing points
        for (var _test=0;_test<ds_list_size(ls_points);_test++){
            var _test_node = ds_list_find_value(ls_points,_test);
            if (point_distance(xx,yy,_test_node.x,_test_node.y)<=_cellSize){
                //This doesn't work, we want to fail out of this inner for loop.
                _valid = false; 
				_test = infinity;
            }
        }
        if (_valid) {ds_list_add(ls_points,new vec2(xx,yy))}
        if (ds_list_size(ls_points)>=_points_needed){i=infinity;}
    }

    return ls_points;

}
#endregion
///@description Parses a / delimited string into a GMS2 DateTime object
///@param timeStampString
function parseTimestamp(_arg0){
	//lastLogin="9/3/2020"
	var array = _arg0;
	var today = date_current_datetime();
	var year = array[2];
	//Android uses a 6 digit datestamp that GMS2 DOES NOT LIKE
	if (string_length(year)==2){
		year = "20"+year;}//I guess technically I'm hardcoding the 20...but it'll be good for like 980 years.
	var lastTimestamp = date_create_datetime(year, array[0], array[1], date_get_hour(today),date_get_minute(today), date_get_second(today));
	return lastTimestamp;
}

///@desc Returns if a given instance is visible in camera
///@param camera
///@param id
function instanceOnCamera(_cam,_id,_buffer=0){

	//Locals
	var __left = camera_get_view_x(_cam);
	var __right = __left+camera_get_view_width(_cam);
	var __top = camera_get_view_y(_cam);
	var __bottom = __top + camera_get_view_height(_cam);
	
	return (_id.bbox_right>=__left && _id.bbox_left <=__right && _id.bbox_bottom>=__top && _id.bbox_top<=__bottom);	
}

///@desc Inclusive between
///@param value
///@param min
///@param max
function isBetween(_arg0, _arg1, _arg2) {
	return (_arg0>=_arg1 && _arg0<=_arg2);
}

///@desc sets image_xscale and image_yscale
///@param image_scale
function image_scale(_arg0) {
	image_xscale = _arg0;
	image_yscale = image_xscale;
}
function instance_all(_object_index){
	var __array = array_create(instance_number(_object_index));
	for (var __i = 0; __i < instance_number(_object_index); ++__i;)
	{
	    __array[__i] = instance_find(_object_index,__i);
	}
	return __array;
}

function instance_random(_object_index) {
	var __count = instance_number(_object_index);
	if (__count==0) return noone;
	
	var __i = floor(random(__count));
	return instance_find(_object_index,__i);
}

///instance_nth_nearest(object, x, y, n);
///@param object
///@param x
///@param y
///@param n(2_is_excluding_self)
function instance_nearest_n() {

	var arg_obj = argument[0];
	var arg_x = argument[1];
	var arg_y = argument[2];
	var arg_n = argument[3];

	var list = ds_priority_create();
	arg_n = clamp(arg_n, 1, instance_number(arg_obj));
	var nearest = noone;

	with (arg_obj)
	{
		ds_priority_add(list, id, distance_to_point(arg_x, arg_y));
	}

	repeat (arg_n)
	{
		nearest = ds_priority_delete_min(list);
	}

	ds_priority_destroy(list);
	return nearest;
}

function instance_nearest_faction(_x,_y,_faction){
	
	//var __arrayOfResults = array_create(1,0);
	var __currentDist = infinity;
	var __result = -1;
	
	with (obj_agent){
		if (faction!=_faction){
			var __dist = point_distance(x,y,_x,_y);
			if (__dist<__currentDist){
				__result = id;	
				__currentDist = __dist;
			}
			//return id;
		}
	}
	
	return __result;
	//return instance_nearest_in_array(_x,_y,__arrayOfResults);
	
}

//Should work now...
function instance_nearest_variable_value(_x,_y,_object_index,_variableName,_variableValue,_trueOrFalse=true){
	
	//var __arrayOfResults = array_create(1,0);
	var __currentDist = 100000;
	var __result = -1;
	
	with (_object_index){
		if ((variable_instance_get(id,_variableName)==_variableValue)==_trueOrFalse){
			var __dist = point_distance(x,y,_x,_y);
			if (__dist<__currentDist){
				__result = id;	
				__currentDist = __dist;
			}
			//return id;
		}
	}
	
	return __result;
	//return instance_nearest_in_array(_x,_y,__arrayOfResults);
	
}

function ds_list_pop_last(_list){
	var _last = ds_list_size(_list)-1;
	if (_last<=-1){return undefined;}
	var __val = ds_list_find_value(_list,_last);
	ds_list_delete(_list,_last);
	return __val;
}
function ds_list_pop_first(_list){
	var _last = 0;
	if (ds_list_size(_list)<=0){return undefined;}
	var __val = ds_list_find_value(_list,_last);
	ds_list_delete(_list,_last);
	return __val;
}

function instance_nearest_notme(_x,_y,_object_index){
	var __array = object_get_instances(_object_index,true);
	return (instance_nearest_in_array(_x,_y,__array));
}

///@desc Returns the closest instance of out the ids in the array provided;
function instance_nearest_in_array(_x,_y,_array) {
	var list = ds_priority_create();
	var nearest = noone;

	for (var i=0;i<array_length(_array);i++){
		var __id = _array[i];
		ds_priority_add(list, __id, point_distance(__id.x,__id.y,_x, _y));
	}
	
	nearest = ds_priority_find_min(list);
	
	ds_priority_destroy(list);
	return nearest;
}

///@desc Returns the nearest 1 instance out of many possible object indices
///@param x
///@param y
///@param types...
function instance_nearests() {

	var nearest=-1;
	var dist=infinity;
	var currentNearest=-1;

	var i, arg;
	for (i = 2; i < argument_count; i++;)
	   {
			 currentNearest=instance_nearest(argument[0],argument[1],argument[i]);
			  if (instance_exists(currentNearest)){
				  var currentDist=point_distance(argument[0],argument[1],currentNearest.x,currentNearest.y);
				  if (currentDist<dist){
					dist=currentDist;
					nearest=currentNearest;
				  }
			  }
	}
  
	return nearest;
}

///@desc Returns the nearest instance of the Object Indices supplied in the array
///@param _x
///@param _y
///@param _arrayOfTypes
function instance_nearest_array(_x,_y,_arrTypes) {

	var nearest=-1;
	var dist=infinity;
	var currentNearest=-1;
	var __typeCount = array_length(_arrTypes)

	var i, arg;
	for (i = 0; i < __typeCount; i++;)
	   {
			 currentNearest=instance_nearest(_x,_y,_arrTypes[i]);
			  if (instance_exists(currentNearest)){
				  var currentDist=point_distance(_x,_y,currentNearest.x,currentNearest.y);
				  if (currentDist<dist){
					dist=currentDist;
					nearest=currentNearest;
				  }
			  }
	}
  
	return nearest;
}




///@desc Returns the nearest instance of objects that have the supplied tag, or array of tags.
///@param _x
///@param _y
///@param _tag(String or Array)
function instance_nearest_tag(_x,_y,_tag){
	var _arrTypes = tag_get_asset_ids(_tag,asset_object);
	return (instance_nearest_array(_x,_y,_arrTypes));
}

#region Settings


function setting_set_real(_section, _key, _value) {
	ini_open("settings.ini");
	ini_write_real(_section,_key,_value);
	ini_close();
}

function setting_set_string(_section, _key, _value) {
	ini_open("settings.ini");
	ini_write_string(_section,_key,_value);
	ini_close();
}

function setting_get_real(_section,_key,_value=undefined) {

	ini_open("settings.ini");

	var __thing = ini_read_real(_section,_key,_value);

	ini_close();

	return __thing;
}

function setting_get_string(_section,_key,_value=undefined) {

	ini_open("settings.ini");

	var __thing = ini_read_real(_section,_key,_value);

	ini_close();

	return __thing;
}

#endregion

#region UNLOCKS/PROGRESS

	function ini_set(_file,_section,_key,_value) {
		ini_open(_file);
		if (is_real(_value)){
			ini_write_real(_section,_key,_value);
		}
		else {
			ini_write_string(_section,_key,_value);
		}
		ini_close();
	}
	
	function ini_get_real(_file,_section,_key,_default){
		ini_open(_file);
		var __i = ini_read_real(_section,_key,_default);
		ini_close();
		return __i;
	}
	
	function ini_get_string(_file,_section,_key,_default){
		ini_open(_file);
		var __i = ini_read_string(_section,_key,_default);
		ini_close();
		return __i;
	}
	
	function metaprogress_set(_section,_key,_value){
		ini_set("progress.ini",_section,_key,_value);
	}
	function metaprogress_get_real(_section,_key,_value){
		return ini_get_real("progress.ini",_section,_key,_value);
	}
	function metaprogress_get_string(_section,_key,_value){
		return ini_get_string("progress.ini",_section,_key,_value);
	}

#endregion
#region ARRAYS

function arrays_difference(_a,_b){
	var __output = array_create(array_length(_a),0);
	for (var i = 0; i < array_length(_a); ++i) {	
		__output[i] = _a[i] - _b[i];
	}
	return __output;
}

function arrays_sum(_a,_b){
	var __output = array_create(array_length(_a),0);
	for (var i = 0; i < array_length(_a); ++i) {	
		__output[i] = _a[i] + _b[i];
	}
	return __output;
}

function array_to_ds_list(_arr){
	var __arr = _arr
	var __list = ds_list_create()
	array_foreach(__arr, 
		method(
			{list: __list},
			function(_val, _idx){
				ds_list_add(list, _val)
			}
		)
	)
	return __list
}

function array_create_2d(_w,_h,_value=0){

	if (_w <=0 || _h<=0){return undefined;}

	var __array;

	for(var i = 0; i < _h; i++){
	  for(var j = 0; j < _w; j ++){
	    __array[j][i] = _value;
	  }
	}
	
	return __array;
}

function array_foreach_2d(_array,_func){
    var _h = array_length(_array);
    for(var i = 0; i < _h; i++){
        var _w = array_length(_array[i]);
        for(var j = 0; j < _w; j ++){
            _func(_array[i][j], i, j);
        }
    }
}


function array_contains(_array, _value) {
	return (array_find(_array,_value)>=0)
}

/// @desc Function Description
/// @param {array} ArrayToSearch Description
/// @param {any*} KeyToFind Description
/// @returns {real} Description
function array_find(_arg0, _arg1) {
	for (var i=0;i<array_length(_arg0);i++){
		var value = array_get(_arg0,i)
		if (value==_arg1){return i;}
	}
	return -1;
}
/**
 * Function Description
 * @param {array} _array  Description
 * @param {any} _value  Description
 * @returns {bool} Description
 */
function array_contains_2d(_array, _value){
	for(var __i=0;__i<array_length(_array);__i++){
		var _elem = _array[__i]
		if(array_contains(_elem, _value)){
			return true
		}
	}
	return false;
}
/**
 * Function Description
 * @param {array} _array Description
 * @param {any} _key Description
 * @returns {bool} Description
 */
function deeparray_contains(_array, _key){
	for (var i=0;i<array_length(_array);i++){
		
		var value = array_get(_array,i)		
		if (value==_key){return true;}
		
		if (is_array(value))
		{
			var __recursionSuccess = deeparray_contains(value,_key);	
			if (__recursionSuccess) {return true;}
		}
		
	}
	return false;
}

///@param ArrayToSearch
function arrayFindFreePlace(_arg0) {
	return array_contains(_arg0,-1);
}

function array_shuffle(_array) {
	var _len = array_length(_array), _last = 0, _i = 0;
	while(_len) {
		_i = irandom(--_len);
		_last = _array[_len];
		_array[_len] = _array[_i];
		_array[_i] = _last;
	}
	return _array;
}

function array_get_random(_array){
	var __len = array_length(_array);
	return _array[floor(random(__len))];
}

#endregion

#region DATA STRUCTURES TO ARRAYS

function ds_list_to_array(_list,_destroy = false){
	var __size = ds_list_size(_list)-1;
	var __array = array_create(__size);
	for (var __i=__size;__i>=0;__i--){
		__array[__i]=(ds_list_find_value(_list,__i));	
	}
	if (_destroy){
		ds_list_destroy(_list);
	}
	return __array;
}

///@desc Produces an array of distinct values from a ds_list
function ds_list_to_set(_list,_destroy = false){
	var __array = []
	set_push(__array,ds_list_to_array(_list,_destroy))
	return __array
}

#endregion

#region SETS
///Some wrapper functions that pretend an array is a set.
///@desc Pushes either a single element or array of elements following Set theory;
function set_push(_array,_keys){
	if (is_array(_keys)){
		for (var i = 0; i < array_length(_keys); ++i) {
		    var _key = _keys[i];
			if !(array_contains(_array,_key)){
				array_push(_array,_key);	
			}
		}
	}
	else {
		if !(array_contains(_array,_keys)){
			array_push(_array,_keys);	
		}
	}
}

#endregion

#region BAGS

function Bag(_array=[]) constructor{
	
	items = _array;
    index = -1;
	
	pop = function(){
		if (isEmpty()){return undefined;}
		var __i = index> -1 
				  ? index 
				  : rummage();
		var __item = items[__i];
		array_delete(items,__i,1);
		index = -1;
		return __item;
	}

	add = function(_items){
		//if (is_array(_items)){array_concat(items,_items); return;}
		index = -1;
		array_push(items,_items);
	}
	
	peek = function(){
		if (isEmpty()){return undefined;}
		index = index > -1 
				? index 
				: rummage();
		return items[index];			
	}
	
	rummage = function(){
		var _index = irandom_range(0,size()-1);
		return _index;
	}
	
	size = function(){
		return array_length(items);	
	}	
	isEmpty = function(){
		return size() == 0;
    }
	toString = function(){
		return to_string(items, STRING_DISPLAY.IN_LINE);
	}
	empty = function(){
		array_delete(items, 0, size());
	}
}
#endregion

#region Pile
//Nuthin' to see here
function Pile(_array=[]) constructor{
	
	items = _array;

	pop_first = function(){
		if (isEmpty()){return undefined;}
		var __item = items[0];
		array_delete(items,0,1);
		return __item;
	}
	pop_last = function(){
		if (isEmpty()){return undefined;}
		var __item = array_pop(items);
		return __item;
	}
	push_first = function(_items){
		array_insert(items, 0, _items)			
	}
	push_last = function(_items){
		array_push(items,_items);			
	}
	peek_first = function(){
		if (isEmpty()){return undefined;}
		return items[0];			
	}
	peek_last = function(){
		if (isEmpty()){return undefined;}
		return items[(size()-1)]		
	}
	size = function(){
		return array_length(items);	
	}
	isEmpty = function(){
		return size() == 0;
    }
	toString = function(){
		return to_string(items, STRING_DISPLAY.IN_LINE);
	}
	burn = function(){
		array_delete(items, 0, size());
	}
}
#endregion


///@desc Determines if an object has any children objects in the Asset Browser
///@param object_index
function object_has_children(_arg0){
	var OBJECTS_BEGIN = 1;
	var OBJECTS_END = 100000;
	var _ancestor = _arg0;

	for (var i=OBJECTS_BEGIN;i<OBJECTS_END;i++){
		var __obj = i;
		if (object_exists(__obj)){
			if (object_is_ancestor(__obj,_ancestor)){
				return true;
			}
		}
	}
	return false;
}

///@desc Regular old point vector
///@param x
///@param y
function vec2(_x, _y) constructor{
    x = _x;
    y = _y;
	
	static Set = function(_x,_y){
		x = _x;
		y = _y;
		return self;
	}
	
    static Add = function( _other )
        {
        x += _other.x;
        y += _other.y;
		return self;
        }

	static Subtract = function( _other )
        {
        x -= _other.x;
        y -= _other.y;
		return self;
        }
    static Multiply = function( _scalar )
        {
		gml_pragma("forceinline");
		x *= _scalar;
		y *= _scalar;
		return self;
		}
    static Divide = function( _scalar ){
		gml_pragma("forceinline");
		x /= _scalar;
		y /= _scalar;
		return self;
	}
	static rotate = function(_delta) {
		gml_pragma("forceinline");
		//_delta= (_delta / 57.2958);
         //_delta *= 57.2958;
		 _delta=degtorad(_delta)
            var ca =cos(_delta);
            var sa =sin(_delta);
            var rx = x * ca - y * sa;

            y = (x * sa + y * ca);
            x = rx;
			//show_message(self);
	}	
		
		
	static negate = function() {
		x = -x;
		y = -y;
	}
	static get_direction = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, x, y);
	}
	static Distance = function(_pos) {
		gml_pragma("forceinline");
		return point_distance(x, y, _pos.x, _pos.y);
	}	
	static Normalize = function() {
		gml_pragma("forceinline");
		if ((x != 0) || (y != 0)) {
			var _factor = 1/sqrt((x * x) + (y * y));
			x = _factor * x;
			y = _factor * y;	
		}
		return self;
	}
	
	static set_to_velocity = function(_direction,_accel) {
		gml_pragma("forceinline");
		var __x = lengthdir_x(_accel,_direction);
		var __y = lengthdir_y(_accel,_direction);
		x = __x;
		y = __y;
	}
	
	static get_magnitude = function() {
		gml_pragma("forceinline");
		return point_distance(0, 0, x, y);
    }
	
	static set_magnitude = function(_scalar) {
		gml_pragma("forceinline");
		Normalize();
		Multiply(_scalar);	
	}
	
	static limit_magnitude = function(_limit) {
		gml_pragma("forceinline");
		if (get_magnitude() > _limit) {
			set_magnitude(_limit);
		}
	}
	
	static copy = function(_vector) {
		x = _vector.x;
		y = _vector.y;
	}

}

//Children/Extensions of the Main Vector Struct
function vector_zero() : vec2() constructor {
    x = 0;
    y = 0;
}

function vector_random(_length = 1) :  vec2() constructor {
	var _dir = random(360);
    x = lengthdir_x(_length, _dir);
    y = lengthdir_y(_length, _dir);
}

function vector_lengthdir(_length, _dir) :  vec2() constructor {
    x = lengthdir_x(_length, _dir);
    y = lengthdir_y(_length, _dir);
}

//Vector Functions Don't Modify the Original Vector
function vector_copy(_vector) {
	return new  vec2(_vector.x, _vector.y);
}

function vector_add(_vector_a, _vector_b) {
	return new vec2((_vector_a.x + _vector_b.x), (_vector_a.y + _vector_b.y));
}

function vector_subtract(_vector_a, _vector_b) {
	return new vec2((_vector_a.x - _vector_b.x), (_vector_a.y - _vector_b.y));
}

function vector_distance(_vector_a,_vector_b){
	return point_distance(_vector_a.x,_vector_a.y,_vector_b.x,_vector_b.y);
}

function vector_direction(_vector_a,_vector_b){
	return point_direction(_vector_a.x,_vector_a.y,_vector_b.x,_vector_b.y);
}

#region Shapes

function Line(_startPoint,_endPoint) constructor{
	startPoint = _startPoint;
	endPoint = _endPoint;

	static get_length = function(){
		return vector_distance(startPoint,endPoint);
	}

	static get_direction = function(){
		return vector_direction(startPoint,endPoint);
	}
}

function Ray(_distance,_direction) constructor{
	
}

function Shape() constructor{

}

function Triangle(_pointA,_pointB,_pointC):Shape() constructor{

}

function Square(_pointA,_pointB):Shape() constructor {

}

function Rectangle(_pointA,_pointB,_pointC,_pointD) constructor{
	startPoints = _startPoint;
	endPoint = _endPoint;
}



#endregion

///@desc Returns an array of all the instances of the give object_index
function object_get_instances(_object_index,_notme = false){
	var __arr = array_create(0);
	for (var i = 0; i < instance_number(_object_index); ++i;)
	    {
			var __id = instance_find(_object_index,i);
			if (_notme && __id == id) continue;
			__arr[i] = __id;
	    }
	return __arr;
}

function instance_create_singleton(_object_index){
	if (!instance_exists(_object_index)){
		return instance_create_depth(0,0,0,_object_index);	
	}
	return instance_nearest(0,0,_object_index);
}

function instance_create(_x,_y,_object_index){
	return (instance_create_depth(_x,_y,0,_object_index));
}

function instance_create_z(_x,_y,_z,_object_index){
	var __i = instance_create_depth(_x,_y,-_z,_object_index);
	__i.z = _z;
	return __i;
}

#region TRAITS

function trait_init(){
	traits=-1;	
}

function agentHasTrait(_who,_trait){
	with (_who){
		return (hasTrait(_trait))	
	}
}

function hasTrait(_trait){
	if (traits!=-1) {
		return (array_contains(traits,_trait));
	}
	return false;
}

function addTrait(_trait){
	if (traits=-1){
		traits=array_create(1,_trait);	
	}
	else {
		array_push(traits,_trait);	
	}
}
function removeTrait(_trait){
	//if (live_call(argument0)) return live_result;
	if (!hasTrait(_trait)) return;
	else {
		var __pos = array_find(traits,_trait)
		if (__pos>=0){
			array_delete(traits,__pos,1);
		}
	}
}

function toggleTrait(_trait,_bool){
	if (_bool){
		addTrait(_trait);
	} 
	else {
		removeTrait(_trait);
	}
}

#endregion


function draw_text_color_bold(_x,_y,_string,_scale,_sep,_width,_c,_a){
	draw_text_ext_transformed_color(_x + 2,_y + 2,_string,_sep,_width,_scale,_scale,0,0,0,0,0,_a);
	draw_text_ext_transformed_color(_x,_y,_string,_sep,_width,_scale,_scale,0,_c,_c,_c,_c,_a);	
}

#region tiles and tilesets

function tilemap_foreach(_tilemap,_func,_executeOnEmpty=false){
	var __rows = tilemap_get_height(_tilemap);
	var __columns = tilemap_get_width(_tilemap);
	for (var __x=0; __x<__columns;__x++){
		for (var __y=0;__y<__rows;__y++){
			var __tile = tilemap_get(_tilemap,__x,__y);
			if (__tile==0 && !_executeOnEmpty) continue;
			if (__tile>=0){
				_func(__x,__y,__tile);	
			}
		}
	}
}

function tileset_get_count(_ts_asset){
	return tileset_get_info(_ts_asset).tile_count	
}

function tileset_get_size(_ts_asset){
	var __data = tileset_get_info(_ts_asset)
	var _id = tileset_get_texture(_ts_asset)
	var __width = __data.width 
	var __height = __data.height

	return new vec2(__width, __height)
}

function tileset_exists(_ts_asset_index){
	var _name = tileset_get_name(_ts_asset_index);
	var _isstring = is_string(_name);
	if (is_undefined(_name) || _name ="<undefined>") return false;
	else return true;
}

function tileset_assets_get_all(){
	var _array = [];
	var _index = 0;

	while (tileset_exists(_index))
	{
		array_push(_array,_index++);
	}
	return _array;
}

function sprite_assets_get_all(){
	var _array = [];
	var _index = 0;

	while (sprite_exists(_index))
	{
		array_push(_array,_index++);
	}
	return _array;
}

function sprite_assets_get_all_names(){
	var _array = [];
	var _index = 0;

	while (sprite_exists(_index))
	{
		var __name = sprite_get_name(_index++);
		array_push(_array,__name);
	}
	return _array;
}


#endregion

#region Struct

/// @function                       deep_copy(ref)
/// @param {T} ref                  Thing to deep copy
/// @returns {T}                    New array, or new struct, or new instance of the class, anything else (real / string / etc.) will be returned as-is
/// @description                    Returns a deep recursive copy of the provided array / struct / constructed struct

function deep_copy(ref) {
    var ref_new;
    
    if (is_array(ref)) {
        ref_new = array_create(array_length(ref));
        
        var length = array_length(ref_new);
        
        for (var i = 0; i < length; i++) {
            ref_new[i] = deep_copy(ref[i]);
        }
        
        return ref_new;
    }
    else if (is_struct(ref)) {
        var base = instanceof(ref);
        
        switch (base) {
            case "struct":
            case "weakref":
                ref_new = {};
                break;
                
            default:
                var constr = method(undefined, asset_get_index(base));
                ref_new = new constr();
        }
        
        var names = variable_struct_get_names(ref);
        var length = variable_struct_names_count(ref);
        
        for (var i = 0; i < length; i++) {
            var name = names[i];
            
            variable_struct_set(ref_new, name, deep_copy(variable_struct_get(ref, name)));
        }
        
        return ref_new;
    } else {
        return ref;
    }
}

function struct_copy(_struct, _ignore_functions = false, _copy_static = true){
	if(_struct==undefined) return undefined;
    var __new_struct = {};
    var __function_names_list = variable_struct_get_names(_struct);
    for(var __i = 0; __i< array_length(__function_names_list); __i++){    
        var __name = __function_names_list[__i];
        var __val = variable_struct_get(_struct, __name);
		if(_ignore_functions&&is_method(__val))continue;
        variable_struct_set(__new_struct, __name, __val);
    }
	if(_copy_static){
		static_set(__new_struct,static_get(_struct));
	}
    return __new_struct;
}

function struct_map(__source, __dest, _ignore_functions = false){
	if(__source==undefined) return undefined;
    var __new_struct = __dest;
    var __function_names_list = variable_struct_get_names(__source);
    for(var __i = 0; __i< array_length(__function_names_list); __i++){    
        var __name = __function_names_list[__i];
        var __val = variable_struct_get(__source, __name);
		if(_ignore_functions&&is_method(__val))continue;
        variable_struct_set(__new_struct, __name, __val);
    }
    return __new_struct;
}

/// @desc Function Description
/// @param {struct} _struct Description
/// @param {any} _struct_or_constr Description
/// @param {bool} [_overwrite]=true Description
function set_struct_type(_struct, _struct_or_constr, _overwrite = true){
	if(_struct_or_constr==undefined)return;
	if(is_method(_struct_or_constr)){
		_struct_or_constr = new _struct_or_constr();
	}
	var __function_names_list = variable_struct_get_names(_struct_or_constr);
	for(var __i = 0; __i< array_length(__function_names_list); __i++){	
		var __name = __function_names_list[__i];
		if(!_overwrite && variable_struct_exists(_struct, __name))continue;
		var __val = variable_struct_get(_struct_or_constr, __name);
		var __val_2 = variable_struct_get(_struct, __name)
		if(instanceof(__val_2)=="weakref") {
			continue;
		}
		variable_struct_set(_struct, __name, __val);
	}
	delete _struct_or_constr;
}

/**
 *  Function Description
 * @param {struct} _struct  Description
 * @param {struct, function} _interface  Description
 * @param {bool} [_ignore_functions]=false Description
 * @returns {bool}  Description
 */
function is_struct_of_type(_struct, _interface, _ignore_functions = false){
	var __interface_names_list = variable_struct_get_names(_interface);
	for(var __i = 0; __i< array_length(__interface_names_list); __i++){	
		var __name = __interface_names_list[__i];
		var __val = variable_struct_get(_interface, __name)
		if(is_ptr(__val))continue;
		if(instanceof(__val)=="weakref")continue;
		if(_ignore_functions && is_method(__val))continue;
		
		if(!variable_struct_exists(_struct, __name)){
			return false;
		}
	}
	return true;
}

function struct_typeof(_struct, _constrs = undefined){
	var _target_struct = undefined;
	var __constrs = _constrs==undefined
					?CONSTRUCTORS
					: _constrs;
	var __constrs_length = array_length(__constrs);
	for(var __i=0;__i<__constrs_length;__i++){
		var __constr = __constrs[__i];
		_target_struct = new __constr(0,0,0,0,0,0,0,0,0,0,0,0)
		if(is_struct_of_type(_struct, _target_struct, true)){
			struct_clear(_target_struct);
			return constructor_get_name(__i); //__constr;
		}
		struct_clear(_target_struct);
	}
	return undefined;
}

function struct_clear(_struct){
	var __struct_names = variable_struct_get_names(_struct)
	var __names_length = array_length(__struct_names);
	for(var __i=0;__i<__names_length;__i++){
		var __prop_name	= __struct_names[__i]
		variable_struct_remove(_struct, __prop_name);
	}
	delete _struct;
}

/**
 *  Creates a new struct type based on the anon struct
 * @param {struct} _source_struct  The anon struct to be normalized
 * @returns {struct}  _target_struct The normalized struct
 */
function set_struct_normalized(_source_struct){
	_source_struct = struct_new(_source_struct);
	//struct_clear(_source_struct);
	//Iterate through the struct properties and normalize all structs
	var __struct_names = variable_struct_get_names(_source_struct)
	var __names_length = array_length(__struct_names);
	for(var __i=0;__i<__names_length;__i++){
		var __prop_name	= __struct_names[__i]
		var __prop_val	= variable_struct_get(_source_struct, __prop_name);
		if(instanceof(__prop_val)=="weakref")continue;
		if(is_ptr(__prop_val))continue;
		if(is_method(__prop_val))continue;
		if(is_struct(__prop_val)){
			set_struct_normalized(__prop_val);
		}else if(is_array(__prop_val)&&array_length(__prop_val)>0){
			set_structs_normalized(__prop_val);
		}
	}
}

/**
 * Function Description
 * @param {array<struct>} _struct_array Description
 */
function set_structs_normalized(_struct_array){
	//Iterate through the array and normalize all structs
	var __names_length = array_length(_struct_array);
	for(var __i=0;__i<__names_length;__i++){
		var __target = _struct_array[__i];
		if(is_struct(__target)){
			set_struct_normalized(weak_ref_create(__target))
		}else if(is_array(__target)){
			set_structs_normalized(__target)
		}
	}
}

/**
 * Function Description
 * @param {struct} _struct Description
 * @returns {struct} Description
 */
function get_new_from_anon(_struct){
	var __target_struct = undefined;
	var __constrs = CONSTRUCTORS
	var __constrs_length = array_length(__constrs);
	for(var __i=0;__i<__constrs_length;__i++){
		__target_struct = new __constrs[__i](0,0,0,0,0,0,0,0,0,0,0,0)
		if(is_struct_of_type(_struct, __target_struct, true)){
			set_struct_type(__target_struct, _struct, true);
			struct_clear(_struct);
			return __target_struct;
		}
	}
	return _struct;
}

function new_instanceof(_struct){
	var _base = instanceof(_struct);      
	switch (_base) {
	    case "struct":
	    case "weakref":
	        return {};
	        break;
			
	    default:
	        // Feather disable once GM1041
	        var _constr = method(undefined, asset_get_index(_base));
	        return new _constr();
	}
}


function array_of_structs_copy(_source,_r=0){
	log("RECURSION DEPTH:"+string(_r))
	if (!is_array(_source)){
		show_debug_message("array_of_structs_copy() - source is not an Array");
		return;
	}

	var __len = array_length(_source);
	
	var __newArray = array_create(__len,undefined);
	
	for (var i = 0; i < __len; ++i) {
	    var __var = _source[i];
		//if (is_struct(__var)){
		//	log("Found a struct in our array:");
		//	__newArray[i]=struct_copy(__var);
		//}
		//else if (is_array(__var)){
		//	__newArray[i]=array_of_structs_copy(i,r+1);	
		//}
		//else {
			__newArray[i]=__var;
		//}
	}
	
	return __newArray;
}

/// @description copies over a struct into a new struct
/// @function struct_copy(struct_ref)
/// @param struct_ref the reference to the struct to be copied
function struct_copy_old(ref){

	log("struct_copy()");

	if (is_struct(ref)) {
		
		 //shows struct to be copied in debug output window
		show_debug_message("function struct_copy() - original struct:"); show_debug_message(ref);
		
        var base = instanceof(ref);
		var ref_new;
        log(base);
        switch (base) {
            case("struct"):
            case("weakref"):
                ref_new = {};
            break;

			case undefined:
				//TODO:
				//Doesn't work???
			break;

            default:
                var constr = method(undefined, asset_get_index(base));
                ref_new = new constr();
        }
        
        var names = variable_struct_get_names(ref);
        var length = variable_struct_names_count(ref);
        
        for (var i = 0; i < length; i++) {
            var name = names[i];
			var __var = variable_struct_get(ref,name);
            
			if (is_struct(__var)){
				__var = struct_copy(__var);
			}
			
			variable_struct_set(ref_new, name, __var);
			
        }
        
		//shows new struct in debug output window
		show_debug_message("function struct_copy() - new struct:"); show_debug_message(ref_new);
        return ref_new;
		
    } else {
		
		show_debug_message("function struct_copy() - argument is not a struct. It cannot be copied.")
		var empty_struct = {};
		return empty_struct;
		
	}

}	

#endregion

#region SEQUENCES


function sequence_sprite_swap(_seqID,_sprite,_spriteSwapped){
	var myseq = is_struct(_seqID) ? _seqID : sequence_get(_seqID);
	var __stackGraphicsTracks = ds_stack_create();
	var __stackFolderTracks = ds_stack_create();
	ds_stack_push(__stackFolderTracks,myseq);
	while (!ds_stack_empty(__stackFolderTracks)){
		var __seq = ds_stack_pop(__stackFolderTracks);
		var __tracks = __seq.tracks;
		var __tracksCount = array_length(__tracks);
		for (var i = 0; i < __tracksCount; ++i) {
			var __track = __tracks[i];
			var __type = __track.type;
			switch (__type){
				case seqtracktype_graphic:
					//Push to stack;
					ds_stack_push(__stackGraphicsTracks,__track)
					if (array_length(__track.tracks)>0){
						ds_stack_push(__stackFolderTracks,__track);
					}
				break;
				case seqtracktype_group:
					//log(__track);
					ds_stack_push(__stackFolderTracks,__track);
				break;
				default:
			}
		}
	}
	//Disgorge the contents of our Ungodly Stack.
	 while(!ds_stack_empty(__stackGraphicsTracks)){
		var __track = ds_stack_pop(__stackGraphicsTracks);
		log("Popped Seq Graphic Track: "+string(__track.name));
		var __keyframes = __track.keyframes;
		var __keyframesCount = array_length(__keyframes);
		for (var j = 0; j < __keyframesCount; ++j) {
			var __keyframe = __keyframes[j];
			var __channels = __keyframe.channels;
			var __channelCount = array_length(__channels);
			for (var k = 0; k < __channelCount; ++k) {
				var __keyframeData = __channels[k];
				var __originalSprite = __keyframeData.spriteIndex;
				if (__originalSprite==_sprite)
				{
					__keyframeData.spriteIndex = _spriteSwapped;	
				}
			}
		}
	}
	//Clean up, clean up, everybody clean up DSDL:KJFS:LDKJFL:KSDJFKL:SDJF:LKSDJF(UIOW#$EYER*()&#%&(WE+(Y+!!%RU@*()$*%R
	ds_stack_destroy(__stackGraphicsTracks);
	ds_stack_destroy(__stackFolderTracks);

	return myseq;
}

function sequence_copy_html5(_seq){
	
	var __originalSeq = sequence_get(_seq);
	
	var __newSeq = sequence_create();
	
	if (is_struct(__newSeq)){
		log("Sequence Object Structs Are Structs");	
	}
	else {
		log("Sequence Object Structs Are Not Structs");		
	}
	
	log("Original Sequence:");
	log(__originalSeq);
	
	//Stringify failed me.
	//var __s = json_stringify(__originalSeq);
	//var __newSeqData = json_parse(__s);
	//log("JSON STRINGIFY:");
	//log(__s);
	//log("JSONNED:");
	//log(__newSeqData);
		//log("LN:841");
	__newSeq.name =__originalSeq.name;
	__newSeq.loopmode =__originalSeq.loopmode;
	__newSeq.playbackSpeed =__originalSeq.playbackSpeed;
	__newSeq.playbackSpeedType =__originalSeq.playbackSpeedType;
	__newSeq.length =__originalSeq.length;
	__newSeq.volume =__originalSeq.volume;
	__newSeq.xorigin =__originalSeq.xorigin;
	__newSeq.yorigin =__originalSeq.yorigin;
	__newSeq.messageEventKeyframes = array_of_structs_copy(__originalSeq.messageEventKeyframes);
	__newSeq.momentKeyframes = array_of_structs_copy(__originalSeq.momentKeyframes);
	var __tracks =__originalSeq.tracks;
	var __len = array_length(__tracks); 	
	//log("LN:853");
	var __newArray = array_create(__len,undefined);
	array_copy(__newArray,0,__tracks,0,__len)
	__newSeq.tracks = __newArray; //array_of_structs_copy(__originalSeq.tracks);
	
	//Restore originals???? WHY DOES THIS WORK?????
	//log("LN:859");
	__originalSeq.tracks = __newSeq.tracks;
	__originalSeq.messageEventKeyframes = __newSeq.messageEventKeyframes;
	__originalSeq.momentKeyframes = __newSeq.momentKeyframes;
	//log("LN:863");
	//Sanity check;
	//WE WILL NEVER SPEAK OF THIS
	if (os_browser == browser_not_a_browser){
		//if (__originalSeq.toString()!=__originalSeq.toString()){
		//	log("sequence_copy() - original does not equal original")	
		//}
		//if (__originalSeq.toString()!=__newSeq.toString()){
		//	log("sequence_copy() - Copy does not equal original")	
		//}
	}
	if (is_struct(__newSeq.tracks[0])){
		log("Sequence Track Structs Are Structs");	
	}
	else {
		log("Sequence Track Structs Are Not Structs");		
	}
	//}
	//log("LN:878");
	__newSeq.name = "copyOf_"+string(__originalSeq.name);
	
	log("Original Sequence After Copy:");
	log(__originalSeq);
	log("Copied Sequence:");
	log(__newSeq);
	return __newSeq;	
}

#endregion

#region VERLET 
///https://betterprogramming.pub/making-a-verlet-physics-engine-in-javascript-1dff066d7bc5
//https://editor.p5js.org/gelami/sketches/25aU8kaXvl
//https://github.com/marianpekar/cloth-simulation-2d
// max physics iterations per frame
#macro DEFAULT_VERLET_ITERATIONS 100
//Points/Dots
/**
 * @desc A VerletDot object represents a point in a Verlet physics simulation.
 * @param {number} _x - The initial x-coordinate of the VerletDot.
 * @param {number} _y - The initial y-coordinate of the VerletDot.
 * @constructor
 */
function VerletDot(_x,_y) constructor {
	pos = new vec2(_x, _y);
	oldpos = new vec2(_x, _y);
	fric = 0.97;
	groundFriction = 0.7;
	grav = new vec2(0, 1);
	radius = 5;
	color = c_purple;
	mass = 1;
	pinned = false;
	
	tick = function(){
		if (pinned) return;
	    var __vel = vector_subtract(pos,oldpos);
	    __vel.Multiply(fric);
	    oldpos.Set(pos.x, pos.y);
	    pos.Add(__vel);
	    pos.Add(grav);
		constrain();
	  }	
		
	constrain = function(){
		pos.x = clamp(pos.x,0+radius,room_width-radius);
		pos.y = clamp(pos.y,-9999,room_height-radius);
	}
	
	render = function(){
		draw_circle_color(pos.x,pos.y,radius,(pinned ? c_red : color),(pinned ? c_red : c_dkgray),0);	
	}
	
}
//Constraints/Sticks
function VerletStick(_p1, _p2, _length=undefined) constructor {

    startPoint = _p1;
    endPoint = _p2;
    stiffness = 2;
    color = c_purple;
    
    if (is_undefined(_length)) {
      length = startPoint.pos.Distance(endPoint.pos);
    } else {
      length = _length;
    }

	tick = function() {
	
      var __stickCenter = vector_add(startPoint.pos,endPoint.pos).Divide(2);
      var __stickDir = vector_subtract(startPoint.pos,endPoint.pos)
        .Normalize()
        .Multiply(length / 2);

      if (!startPoint.pinned) {
        startPoint.pos = vector_add(__stickCenter, __stickDir);
      }
      if (!endPoint.pinned) {
        endPoint.pos = vector_subtract(__stickCenter, __stickDir);
      }
    }
	
	get_stretched_length = function(){
		return point_distance(startPoint.pos.x,startPoint.pos.y,endPoint.pos.x,endPoint.pos.y);
	}

	constrain = function(){
		
	}
	
	render = function(){
		draw_line_width_color(startPoint.pos.x,startPoint.pos.y,endPoint.pos.x,endPoint.pos.y,stiffness,color,c_dkgray);
	}
}

#endregion

#region 3D Math Nonsense
function coordinate_2d_to_3d(_x, _y, _view_mat, _proj_mat, _zoffset = 0){
	var V = _view_mat;
	var P = _proj_mat;

	var mx = 2 * (_x / window_get_width() - .5) / P[0];
	var my = -2 * (_y / window_get_height() - .5) / P[5];
	var camX = - (V[12] * V[0] + V[13] * V[1] + V[14] * V[2]);
	var camY = - (V[12] * V[4] + V[13] * V[5] + V[14] * V[6]);
	var camZ = - (V[12] * V[8] + V[13] * V[9] + V[14] * V[10]) + _zoffset;

	if (P[15] == 0)
	{    //This is a perspective projection
	    return [V[2]  + mx * V[0] + my * V[1],
	            V[6]  + mx * V[4] + my * V[5],
	            V[10] + mx * V[8] + my * V[9],
	            camX,
	            camY,
	            camZ];
	}
	else
	{    //This is an ortho projection
	    return [V[2],
	            V[6],
	            V[10],
	            camX + mx * V[0] + my * V[1],
	            camY + mx * V[4] + my * V[5],
	            camZ + mx * V[8] + my * V[9]];
	}
}

function mouse_position_3d_get(_camera=view_camera[view_current]){
	var _x = window_mouse_get_x()
	var _y = window_mouse_get_y()
	
	var _viewMat = camera_get_view_mat(_camera);
	var _projMat = camera_get_proj_mat(_camera);
	var _camW = camera_get_view_width(_camera) * 2;
	var _camH = camera_get_view_height(_camera) * 2;
	var __mouse_ray = coordinate_2d_to_3d(_x,_y,_viewMat,_projMat,0);
	var P = _projMat;
	var mouseX = __mouse_ray[3] + (_camW * __mouse_ray[0]);
	var mouseY = __mouse_ray[4] + (_camH *__mouse_ray[1]);
	
	mouseX = __mouse_ray[3] //+ (_camW * __mouse_ray[0]);
	mouseY = __mouse_ray[4] //+ (__mouse_ray[1]);

	var s2w = __mouse_ray;

	var fx = s2w[0] * s2w[5] / -s2w[2] + s2w[3];
	var fy = s2w[1] * s2w[5] / -s2w[2] + s2w[4];
	
	var __pos = {
	
		x: fx,
		y: fy
	
	}
	
	return __pos;
}

#endregion

#region COLLISION LINES, LINE OF SIGHT


function mp_grid_place_empty(_grid,_resolution,_x,_y){
	var __return = mp_grid_get_cell(_grid,_x div _resolution,_y div _resolution);
	return (__return == 0);
}

///@param _startx The x-coordinate of the starting point.
/// @param _starty The y-coordinate of the starting point.
/// @param _direction The direction in which to cast the ray (in degrees).
/// @param _distance The maximum distance the ray can travel.
/// @param _stepSize The distance between each step of the raycast.
/// @param func The function to call for each step of the raycast.
/// @returns The result of the raycast.
function raycast_dir(_startx, _starty, _direction, _distance, _stepSize, func) {
	var __endx = _startx + lengthdir_x(_distance, _direction);
	var __endy = _starty + lengthdir_y(_distance, _direction);
	return raycast(_startx, _starty, __endx, __endy, _stepSize, func);
}




function raycast(_startx,_starty,_endx,_endy,_stepSize,func){
	var __dist = point_distance(_startx,_starty,_endx,_endy);
	var __dir = point_direction(_startx,_starty,_endx,_endy);
	var __steps = ceil(__dist / _stepSize);
	var __x = _startx;
	var __y = _starty;
	var __xdif = lengthdir_x(_stepSize,__dir);
	var __ydif = lengthdir_y(_stepSize,__dir);
	
	for (var i = 0; i < __steps; ++i) {
	   __x += __xdif;
	   __y += __ydif;  
	   var __return = func(__x,__y,_stepSize * i);
	   if (__return!=undefined) return __return;
	}
	return -1;//Means nothing happened, essentially;
}

//Array structure;
// global.tile_los_array = array_create();
// usage:  global.tile_los_array[_mp_grid_to_check];
// returns a flattened 2d array, with each index corresponding to a room tile position like [x,y];
// Each entry in that array is another array, representing all the flattened x,y tile positions that this tile position has LOS to

//Array Structure concept 2:
// step 1:  Get a flattened ID of the X and Y pos of the tile
// step 2:  Create a 2d array. 
// step 3:  Check LOS between two tiles like global.tile_los[_tile1][_tile2];

function array_index_flatten(_x,_y,_width){
	return (_x + (_y * _width));
}

//Called when changing rooms, or any time the Opacity tilemap changes;
//Important to remember that _w and _h are TILE count, not pixel width/height
function init_los_cache(_w=ceil(room_width/16),_h=ceil(room_height/16)){
	//global.los_cache = array_create_2d(_w * _h, _w * _h,undefined);
}

function collision_line_grid_cache(_x1,_y1,_x2,_y2,_grid,_resolution){
	//First, check cache
	//var __w = array_length(global.los_cache);
	//var __tile1 = array_index_flatten(_x1 div _resolution,_y1 div _resolution,__w);
	//var __tile2 = array_index_flatten(_x2 div _resolution,_y2 div _resolution,__w);
	//var __los_cached = global.los_cache[__tile1][__tile2];
	//if (__los_cached!=undefined) return __los_cached;
	//If necessary, do collision check
	var __los = collision_line_grid(_x1,_y1,_x2,_y2,_grid,_resolution);
	//Then, update the cache!
	//global.los_cache[__tile1][__tile2] = __los;
	return __los;
}

function tiles_have_los(_x1,_y1,_x2,_y2,_grid,_resolution){
	var __los = collision_line_grid_cache(_x1,_y1,_x2,_y2,_grid,_resolution);
	if (__los <=0 ) return true;
	return false;
}


//Checks to see if Tile1 has LOS to Tile2 and Tile3 has LOS to Tile2
//The X&Y positions are in pixels
function tiles_have_los_between(_x1,_y1,_x2,_y2,_x3,_y3,_grid,_resolution){
	//var __w = array_length(global.los_cache);
	//var __tile1 = array_index_flatten(_x1 div _resolution,_y1 div _resolution,__w);
	//var __tile2 = array_index_flatten(_x2 div _resolution,_y2 div _resolution,__w);
	//var __tile3 = array_index_flatten(_x3 div _resolution,_y3 div _resolution,__w);

	var __los = collision_line_grid_cache(_x1,_y1,_x2,_y2,_grid,_resolution);
	if (__los>0) return false;
	var __los2 = collision_line_grid_cache(_x3,_y3,_x2,_y2,_grid,_resolution);
	if (__los2>0) return false;
	return true;
}
/// @desc Performs a collision check along a line using a given mp_grid.
/// @param _x1 The x-coordinate of the starting point of the line.
/// @param _y1 The y-coordinate of the starting point of the line.
/// @param _x2 The x-coordinate of the ending point of the line.
/// @param _y2 The y-coordinate of the ending point of the line.
/// @param _grid The mp_grid to use for the collision check.
/// @param _resolution The resolution of the grid cells.
/// @return Returns 1 if a collision is detected, -1 if no collision is found.
function collision_line_grid(_x1,_y1,_x2,_y2,_grid,_resolution){
	// Don't bother checking the same TileData position twice;
	var __lastTileX=-1;
	var __lastTileY=-1;
	
	var __x=_x1,__y=_y1;
	
	var __dir = point_direction(_x1,_y1,_x2,_y2);
	var __dist = point_distance(_x1,_y1,_x2,_y2);
	
	var __stepsRequired = floor(__dist / _resolution)
	
	for (var __step=0;__step<__stepsRequired;__step++){
		__x +=lengthdir_x(__step,__dir);
		__y +=lengthdir_y(__step,__dir);
		var __tileX = __x div _resolution;
		var __tileY = __y div _resolution
		
		if (__tileX!=__lastTileX || __tileY != __lastTileY){
			var __tile = mp_grid_get_cell(global.mpGrid,__tileX,__tileY);
			if (__tile==-1){return 1;}
			__lastTileX=__tileX;
			__lastTileY=__tileY;
		}
	}
	// Found nothing!
	return -1;
}


#endregion

#region STEERING FORCES
function force_seek(_x,_y,_weight=1){
	var _vec = new vec2(_x,_y);
	//var _velocity = new vec2(hspeed,vspeed);
	var _pos = new vec2(x,y);
	_vec.Subtract(_pos);
	_vec.set_magnitude(_weight);
	//_vec.Subtract(_velocity);
	//_vec.limit_magnitude(_max_magnitude);
	return _vec;
}

function force_flee(_x,_y,_weight=1){
	var _vec = new vec2(_x,_y);
	//var _velocity = new vec2(hspeed,vspeed);
	var _pos = new vec2(x,y);
	_vec.Subtract(_pos);
	_vec.set_magnitude(_weight);
	_vec.negate();
	//_vec.Subtract(_velocity);
	//_vec.limit_magnitude(_max_magnitude);
	return _vec;
}

function force_pursue(_target,_force=0.1,_max_magnitude=0.5){
	var _vec = new vec2(_target.hspeed,_target.vspeed);
	_vec.Multiply(6);
	_vec.Add(new vec2(_target.x,_target.y));
	return seek_force(_vec.x,_vec.y,_force,_max_magnitude);
}

function force_evade(_target,_force=0.1,_max_magnitude=0.5){
	var _vec = new vec2(_target.hspeed,_target.vspeed);
	_vec.Multiply(6);
	_vec.Add(new vec2(_target.x,_target.y));
	return force_flee(_vec.x,_vec.y,_force,_max_magnitude);
}

function force_strafe(_target,_force=0.1,_angle=90,_max_magnitude=0.5){
	var _vec = new vec2(x,y);
	_vec.set_magnitude(_force);
	_vec.Add(new vector_lengthdir(_force, facingTarget + _angle));
	_vec.limit_magnitude(_max_magnitude);
	return _vec;
}

function force_arrive(_x,_y,_slowing_radius=64,_force=0.1,_max_magnitude=0.5){
	var _vec = new vec2(_x,_y);
	var _velocity = new vec2(hspeed,vspeed);
	var _pos = new vec2(x,y);
	_vec.Subtract(_pos);
	_vec.set_magnitude(_force);
	_vec.Subtract(_velocity);
	_vec.limit_magnitude(_max_magnitude);
	return _vec;
}

function force_margins(_x,_y,_left,_right,_top,_bottom,_force=1){
	var _vec = new vector_zero();
	if _x < _left{
	    _vec.x = _force;
	}
	if _x > _right{
	    _vec.x = -_force;
	}
	if _y > _bottom{
	    _vec.y = -_force;
	}
	if _y < _top {
	    _vec.y = _force;
	}
	return _vec;
}

function force_wander(_max_magnitude=1,_heading_change = WANDER_CHANGE) {

	var _vec = new vec2(hspeed,vspeed);
	_vec.set_magnitude(WANDER_DISTANCE+random(2));
	_vec.Add(new vector_lengthdir(WANDER_POWER, facing));
	_vec.limit_magnitude(_max_magnitude);
	
	if ((current_time + real(id)) mod 1000 == 0){
		facingTarget +=  random_range(-_heading_change, _heading_change);
	}

	return _vec;

}

function force_wander_perlin(_heading,_perlin_index,_wander_scale=1,_force=3){
	var __angle = (perlin_noise(_perlin_index) * _wander_scale) + _heading;
	var __vec = new vector_lengthdir(_force,__angle);
	return __vec;
}

/**
 * Function Description
 * @param {array} _array Description
 * @returns {struct} Description
 */
function force_separation_list(_array,_power = 0.75,_range=1000) {
	
	var _vec, _count, _vec_to;
	_vec = new vector_zero();
	_count = 0;
	var __pos = new vec2(x,y);
	
	for (var i = 0; i < array_length(_array); i ++ ) {
		var __other = _array[i];
		_vec_to = vector_subtract(__pos, new vec2(__other.x,__other.y));
		var _dist = min(_vec_to.get_magnitude(), _range);
		var _scale = (1 - (_dist/_range));
		_vec_to.Multiply(_scale);
		_vec.Add(_vec_to);
		_count += 1;
	}
	
	if (_count > 0) {
		_vec.set_magnitude(_power);
	}
	
	return _vec;

}

function force_alignment_array(_array,_force = 0.75){
	var __vec_to;
	var __vec = new vector_zero();
	var __count = 0;
	var __pos = new vec2(x,y);
	
	for (var i = 0; i < array_length(_array); i ++ ) {
		var __other = _array[i];
		var __velocity = new vec2(__other.hspeed,__other.vspeed);
		__vec.Add(__velocity);
		__count++;
	}
	
	if (__count>0){
		__vec.set_magnitude(_force);	
	}
	
	return __vec;
}

function force_cohesion_array(_array,_force = 0.2){
	var __vec_to;
	var __vec = new vector_zero();
	var __count = 0;
	//var __pos = new vec2(x,y);
	
	for (var i = 0; i < array_length(_array); i ++ ) {
		var __other = _array[i];
		var __pos = new vec2(__other.x,__other.y);
		__vec.Add(__pos);
		__count++;
	}
	
	if (__count>0){
		__vec.Divide(__count);
		__vec = force_seek(__vec.x,__vec.y,_force);
	}
	
	return __vec;
}


#endregion

#region CONTEXT STEERING
function context_steering(_array,_vec,_weight = 0.5){
	var __directions = array_length(_array);
	var __direction_step = (360 / __directions);
	for (var i = 0; i < array_length(_array); ++i) {
		var __direction_bucket = new vector_lengthdir(1,i * __direction_step);
		var __result = dot_product_normalized(_vec.x,_vec.y,__direction_bucket.x,__direction_bucket.y);
		if (__result>0){
			_array[i]+=(__result * _weight);   
		}
	}
	return _array;
}

function context_steering_compose(_array_decision){
	var _decision_direction = new vector_zero();
	var __directions = array_length(_array_decision)
	var __dir_step = (360 / __directions)
	for (var i = 0; i < __directions; ++i) {	
		var __output_force = _array_decision[i];
		var __vec_direction = new vector_lengthdir(__output_force,__dir_step * i);
		_decision_direction.Add(__vec_direction);
	}
	return _decision_direction;
}

#endregion

#region NOISE

//From https://github.com/samspadegamedev/YouTube-Perlin-Noise-Public/blob/main/scripts/perlin_noise_script_functions/perlin_noise_script_functions.gml
function perlin_noise(_x, _y = 100.213, _z = 450.4215) {
	
	#region //doubled perm table
	static _p = [
		151,160,137,91,90,15,
		131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
		190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
		88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
		77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
		102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
		135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
		5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
		223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
		129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
		251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
		49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
		138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,
		151,160,137,91,90,15,
		131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
		190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
		88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
		77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
		102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
		135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
		5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
		223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
		129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
		251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
		49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
		138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
	];
	#endregion

    static _fade = function(_t) {
        return _t * _t * _t * (_t * (_t * 6 - 15) + 10);
    }

	static _lerp = function(_t, _a, _b) { 
		return _a + _t * (_b - _a); 
	}

    static _grad = function(_hash, _x, _y, _z) {
        var _h, _u, _v;
        _h = _hash & 15;                       // CONVERT 4 BITS OF HASH CODE
        _u = (_h < 8) ? _x : _y;                 // INTO 12 GRADIENT DIRECTIONS.
        if (_h < 4) {
            _v = _y;
        } else if ((_h == 12) || (_h == 14)) {
            _v = _x;
        } else {
            _v = _z;
        }
		if ((_h & 1) != 0) {
			_u = -_u;
		}
		if ((_h & 2) != 0) {
			_v = -_v;
		}		
        return _u + _v;
    }

    var _X, _Y, _Z;
    _X = floor(_x);
    _Y = floor(_y);
    _Z = floor(_z);
    
    _x -= _X;
    _y -= _Y;
    _z -= _Z;
    
    _X = _X & 255;
    _Y = _Y & 255;
    _Z = _Z & 255;
    
    var _u, _v, _w;
    _u = _fade(_x);
    _v = _fade(_y);
    _w = _fade(_z);
    
    var A, AA, AB, B, BA, BB;
    A  = _p[_X]+_Y;
    AA = _p[A]+_Z;
    AB = _p[A+1]+_Z;
    B  = _p[_X+1]+_Y;
    BA = _p[B]+_Z;
    BB = _p[B+1]+_Z;

	//returns a number between -1 and 1
    return _lerp(_w, _lerp(_v, _lerp(_u,_grad(_p[AA  ], _x  , _y  , _z   ),  // AND ADD
										_grad(_p[BA  ], _x-1, _y  , _z   )), // BLENDED
                             _lerp(_u,	_grad(_p[AB  ], _x  , _y-1, _z   ),  // RESULTS
										_grad(_p[BB  ], _x-1, _y-1, _z   ))),// FROM  8
                    _lerp(_v, _lerp(_u,	_grad(_p[AA+1], _x  , _y  , _z-1 ),  // CORNERS
										_grad(_p[BA+1], _x-1, _y  , _z-1 )), // OF CUBE
                             _lerp(_u,	_grad(_p[AB+1], _x  , _y-1, _z-1 ),
										_grad(_p[BB+1], _x-1, _y-1, _z-1 )))); 

}
	
#endregion