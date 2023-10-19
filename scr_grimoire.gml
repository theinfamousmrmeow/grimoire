// If you have any questions, improvements, or requests, let's talk!

#region Input Helpers and Definitions

#macro PRAGMA_FORCE_INLINE gml_pragma("forceinline")

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

#macro CHAR_TILDE 192
#macro CHAR_NEWLINE chr(10)

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
	/// Approach(a, b, amount)
	// Moves "a" towards "b" by "amount" and returns the result
	// Nice bcause it will not overshoot "b", and works in both directions
	// Examples:
	//      speed = Approach(speed, max_speed, acceleration);
	//      hp = Approach(hp, 0, damage_amount);
	//      hp = Approach(hp, max_hp, heal_amount);
	//      x = Approach(x, target_x, move_speed);
	//      y = Approach(y, target_y, move_speed);
 
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
	var __currentDist = 100000;
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

///@desc Returns the closest instance of out the ids in the array provided;
function instance_nearest_in_array(_x,_y,_array) {


	var list = ds_priority_create();
	var nearest = noone;

	for (var i=0;i<array_length(_array);i++){
		ds_priority_add(list, id, distance_to_point(_x, _y));
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
	var dist=100000;
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
	var dist=100000;
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
	
	function progress_set(_section,_key,_value){
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


#endregion

#region DATA STRUCTURES TO ARRAYS

function ds_list_to_array(_list,_destroy = false){
	var __size = ds_list_size(_list);
	var __array = array_create(__size);
	for (var __i=__size;__i>=0;__i++){
		__array[__i]=(ds_list_find_value(_list,__i));	
	}
	if (_destroy){
		ds_list_destroy(_list);
	}
	return __array;
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
	}
	
    static Add = function( _other )
        {
        x += _other.x;
        y += _other.y;
        }

	static Subtract = function( _other )
        {
        x -= _other.x;
        y -= _other.y;
        }
    static Multiply = function( _scalar )
        {
		gml_pragma("forceinline");
		x *= _scalar;
		y *= _scalar;
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
	
	static normalize = function() {
		gml_pragma("forceinline");
		if ((x != 0) || (y != 0)) {
			var _factor = 1/sqrt((x * x) + (y * y));
			x = _factor * x;
			y = _factor * y;	
		}
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
		normalize();
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

function vector_subtract(_vector_a, _vector_b) {
	return new  vec2((_vector_a.x - _vector_b.x), (_vector_a.y - _vector_b.y));
}
///@desc Performs as per collision_line, but using a given mp_grid
function collision_line_grid(_x1,_y1,_x2,_y2,_grid,_resolution){
	//Don't bother checking the same TileData position twice;
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
	//Found nothing!
	return -1;
}

///@desc Returns an array of all the instances of the give object_index
function object_get_instances(_object_index){
	var __arr = array_create(0);
	for (var i = 0; i < instance_number(_object_index); ++i;)
	    {
	    __arr[i] = instance_find(_object_index,i);
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