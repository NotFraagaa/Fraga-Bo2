#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

srswitch()
{
    if(level.plutoversion == 2905)
        return;
    if(getDvarInt("SR") == 0)
        return;
    switch ( getdvarint( "SR" ) )
    {
        case 5: 
            level thread SplitTimer( strtok( "Round 2|Round 3|Round 4|Round 5", "|" ), 40); break;
        case 30: 
            level thread SplitTimer( strtok( "Round 5|Round 10|Round 15|Round 20|Round 25|Round 30", "|" ), 40); break;
        case 50: 
            level thread SplitTimer( strtok( "Round 10|Round 20|Round 30|Round 40|Round 50", "|" ), 40); break;
        case 70: 
            level thread SplitTimer( strtok( "Round 10|Round 20|Round 30|Round 40|Round 50|Round 60|Round 70", "|" ), 40); break;
        case 100: 
            level thread SplitTimer( strtok( "Round 30|Round 50|Round 70|Round 80|Round 90|Round 95|Round 100", "|" ), 40); break;
        case 150: 
            level thread SplitTimer( strtok( "Round 50|Round 70|Round 100|Round 125|Round 130|Round 140|Round 150", "|" ), 40); break;
        case 200: 
            level thread SplitTimer( strtok( "Round 50|Round 70|Round 100|Round 150|Round 175|Round 200", "|" ), 40); break;
        default: break;
    }
    level thread show_splits();
}

SplitTimer(split_list, y_offset)
{
    level endon( "game_ended" );
    flag_wait( "initial_blackscreen_passed" );

    foreach ( split in split_list )
        makeList( split, y_offset );
    level.fraga_splits_start_time = gettime();
    for ( i = 0; i < split_list.size; i++ )
    {
        split = split_list[i];
        splitFinish( split, wait_first_split( split ));
    }
}

makeList(split_name , y_offset)
{
    y = y_offset;

    if ( isdefined( level.fraga_splits_splits ) )
        y = y + level.fraga_splits_splits.size * 16;

    level.fraga_splits_splits[split_name] = newhudelem();
    level.fraga_splits_splits[split_name].alignx = "left";
    level.fraga_splits_splits[split_name].aligny = "center";
    level.fraga_splits_splits[split_name].horzalign = "left";
    level.fraga_splits_splits[split_name].vertalign = "top";
    level.fraga_splits_splits[split_name].x = -62;
    level.fraga_splits_splits[split_name].y = -30 + y;
    level.fraga_splits_splits[split_name].alpha = 0;
    level.fraga_splits_splits[split_name].fontscale = 1.4;
    level.fraga_splits_splits[split_name].hidewheninmenu = 1;
    level.fraga_splits_splits[split_name].finished = 0;
    level.fraga_splits_splits[split_name].color = ( 1, 1, 1 );
    level thread StartSplit( split_name );
    splitLabel( split_name );
}


splitLabel( split_name )
{
    if(GetDvar("language") != "galego" || GetDvar("language") != "spanish")
    {
        switch(split_name)
        {
            case "Round 2": level.fraga_splits_splits[split_name].label = &"^3Round 2 ^7"; break;
            case "Round 3": level.fraga_splits_splits[split_name].label = &"^3Round 3 ^7"; break;
            case "Round 4": level.fraga_splits_splits[split_name].label = &"^3Round 4 ^7"; break;
            case "Round 5": level.fraga_splits_splits[split_name].label = &"^3Round 5 ^7"; break;
            case "Round 5": level.fraga_splits_splits[split_name].label = &"^3Round 5 ^7"; break;
            case "Round 10": level.fraga_splits_splits[split_name].label = &"^3Round 10 ^7"; break;
            case "Round 15": level.fraga_splits_splits[split_name].label = &"^3Round 15 ^7"; break;
            case "Round 20": level.fraga_splits_splits[split_name].label = &"^3Round 20 ^7"; break;
            case "Round 25": level.fraga_splits_splits[split_name].label = &"^3Round 25 ^7"; break;
            case "Round 30": level.fraga_splits_splits[split_name].label = &"^3Round 30 ^7"; break;
            case "Round 40": level.fraga_splits_splits[split_name].label = &"^3Round 40 ^7"; break;
            case "Round 50": level.fraga_splits_splits[split_name].label = &"^3Round 50 ^7"; break;
            case "Round 60": level.fraga_splits_splits[split_name].label = &"^3Round 60 ^7"; break;
            case "Round 70": level.fraga_splits_splits[split_name].label = &"^3Round 70 ^7"; break;
            case "Round 80": level.fraga_splits_splits[split_name].label = &"^3Round 80 ^7"; break;
            case "Round 90": level.fraga_splits_splits[split_name].label = &"^3Round 90 ^7"; break;
            case "Round 95": level.fraga_splits_splits[split_name].label = &"^3Round 95 ^7"; break;
            case "Round 100": level.fraga_splits_splits[split_name].label = &"^3Round 100 ^7"; break;
            case "Round 125": level.fraga_splits_splits[split_name].label = &"^3Round 125 ^7"; break;
            case "Round 130": level.fraga_splits_splits[split_name].label = &"^3Round 130 ^7"; break;
            case "Round 140": level.fraga_splits_splits[split_name].label = &"^3Round 140 ^7"; break;
            case "Round 150": level.fraga_splits_splits[split_name].label = &"^3Round 150 ^7"; break;
            case "Round 175": level.fraga_splits_splits[split_name].label = &"^3Round 175 ^7"; break;
            case "Round 200": level.fraga_splits_splits[split_name].label = &"^3Round 200 ^7"; break;
        }
    }
    if(GetDvar("language") == "galego" || GetDvar("language") == "spanish")
    {
        switch(split_name)
        {
            case "Round 2": level.fraga_splits_splits[split_name].label = &"^3Ronda 2 ^7"; break;
            case "Round 3": level.fraga_splits_splits[split_name].label = &"^3Ronda 3 ^7"; break;
            case "Round 4": level.fraga_splits_splits[split_name].label = &"^3Ronda 4 ^7"; break;
            case "Round 5": level.fraga_splits_splits[split_name].label = &"^3Ronda 5 ^7"; break;
            case "Round 5": level.fraga_splits_splits[split_name].label = &"^3Ronda 5 ^7"; break;
            case "Round 10": level.fraga_splits_splits[split_name].label = &"^3Ronda 10 ^7"; break;
            case "Round 15": level.fraga_splits_splits[split_name].label = &"^3Ronda 15 ^7"; break;
            case "Round 20": level.fraga_splits_splits[split_name].label = &"^3Ronda 20 ^7"; break;
            case "Round 25": level.fraga_splits_splits[split_name].label = &"^3Ronda 25 ^7"; break;
            case "Round 30": level.fraga_splits_splits[split_name].label = &"^3Ronda 30 ^7"; break;
            case "Round 40": level.fraga_splits_splits[split_name].label = &"^3Ronda 40 ^7"; break;
            case "Round 50": level.fraga_splits_splits[split_name].label = &"^3Ronda 50 ^7"; break;
            case "Round 60": level.fraga_splits_splits[split_name].label = &"^3Ronda 60 ^7"; break;
            case "Round 70": level.fraga_splits_splits[split_name].label = &"^3Ronda 70 ^7"; break;
            case "Round 80": level.fraga_splits_splits[split_name].label = &"^3Ronda 80 ^7"; break;
            case "Round 90": level.fraga_splits_splits[split_name].label = &"^3Ronda 90 ^7"; break;
            case "Round 95": level.fraga_splits_splits[split_name].label = &"^3Ronda 95 ^7"; break;
            case "Round 100": level.fraga_splits_splits[split_name].label = &"^3Ronda 100 ^7"; break;
            case "Round 125": level.fraga_splits_splits[split_name].label = &"^3Ronda 125 ^7"; break;
            case "Round 130": level.fraga_splits_splits[split_name].label = &"^3Ronda 130 ^7"; break;
            case "Round 140": level.fraga_splits_splits[split_name].label = &"^3Ronda 140 ^7"; break;
            case "Round 150": level.fraga_splits_splits[split_name].label = &"^3Ronda 150 ^7"; break;
            case "Round 175": level.fraga_splits_splits[split_name].label = &"^3Ronda 175 ^7"; break;
            case "Round 200": level.fraga_splits_splits[split_name].label = &"^3Ronda 200 ^7"; break;
        }
    }
    if(GetDvar("language") == "french")
    {
        switch(split_name)
        {
            case "Round 2": level.fraga_splits_splits[split_name].label = &"^3Manche 2 ^7"; break;
            case "Round 3": level.fraga_splits_splits[split_name].label = &"^3Manche 3 ^7"; break;
            case "Round 4": level.fraga_splits_splits[split_name].label = &"^3Manche 4 ^7"; break;
            case "Round 5": level.fraga_splits_splits[split_name].label = &"^3Manche 5 ^7"; break;
            case "Round 5": level.fraga_splits_splits[split_name].label = &"^3Manche 5 ^7"; break;
            case "Round 10": level.fraga_splits_splits[split_name].label = &"^3Manche 10 ^7"; break;
            case "Round 15": level.fraga_splits_splits[split_name].label = &"^3Manche 15 ^7"; break;
            case "Round 20": level.fraga_splits_splits[split_name].label = &"^3Manche 20 ^7"; break;
            case "Round 25": level.fraga_splits_splits[split_name].label = &"^3Manche 25 ^7"; break;
            case "Round 30": level.fraga_splits_splits[split_name].label = &"^3Manche 30 ^7"; break;
            case "Round 40": level.fraga_splits_splits[split_name].label = &"^3Manche 40 ^7"; break;
            case "Round 50": level.fraga_splits_splits[split_name].label = &"^3Manche 50 ^7"; break;
            case "Round 60": level.fraga_splits_splits[split_name].label = &"^3Manche 60 ^7"; break;
            case "Round 70": level.fraga_splits_splits[split_name].label = &"^3Manche 70 ^7"; break;
            case "Round 80": level.fraga_splits_splits[split_name].label = &"^3Manche 80 ^7"; break;
            case "Round 90": level.fraga_splits_splits[split_name].label = &"^3Manche 90 ^7"; break;
            case "Round 95": level.fraga_splits_splits[split_name].label = &"^3Manche 95 ^7"; break;
            case "Round 100": level.fraga_splits_splits[split_name].label = &"^3Manche 100 ^7"; break;
            case "Round 125": level.fraga_splits_splits[split_name].label = &"^3Manche 125 ^7"; break;
            case "Round 130": level.fraga_splits_splits[split_name].label = &"^3Manche 130 ^7"; break;
            case "Round 140": level.fraga_splits_splits[split_name].label = &"^3Manche 140 ^7"; break;
            case "Round 150": level.fraga_splits_splits[split_name].label = &"^3Manche 150 ^7"; break;
            case "Round 175": level.fraga_splits_splits[split_name].label = &"^3Manche 175 ^7"; break;
            case "Round 200": level.fraga_splits_splits[split_name].label = &"^3Manche 200 ^7"; break;
        }
    }
}

wait_split( split , last_time)
{
    while(true)
    {
        if(isDefined(level.fraga_splits_time))
        {
            time = last_time;
            return;
        }
        wait 1;
    }
    switch ( split )
    {
        case "Round 2":   while ( level.round_number < 2 )    {wait 1; time += 1000;} break;
        case "Round 3":   while ( level.round_number < 3 )    {wait 1; time += 1000;} break;
        case "Round 4":   while ( level.round_number < 4 )    {wait 1; time += 1000;} break;
        case "Round 5":   while ( level.round_number < 5 )    {wait 1; time += 1000;} break;
        case "Round 10":  while ( level.round_number < 10 )   {wait 1; time += 1000;} break;
        case "Round 15":  while ( level.round_number < 15 )   {wait 1; time += 1000;} break;
        case "Round 20":  while ( level.round_number < 20 )   {wait 1; time += 1000;} break;
        case "Round 25":  while ( level.round_number < 25 )   {wait 1; time += 1000;} break;
        case "Round 30":  while ( level.round_number < 30 )   {wait 1; time += 1000;} break;
        case "Round 40":  while ( level.round_number < 40 )   {wait 1; time += 1000;} break;
        case "Round 50":  while ( level.round_number < 50 )   {wait 1; time += 1000;} break;
        case "Round 60":  while ( level.round_number < 60 )   {wait 1; time += 1000;} break;
        case "Round 70":  while ( level.round_number < 70 )   {wait 1; time += 1000;} break;
        case "Round 80":  while ( level.round_number < 80 )   {wait 1; time += 1000;} break;
        case "Round 90":  while ( level.round_number < 80 )   {wait 100; time += 100000;} while ( level.round_number < 90 )   {wait 1; time += 1000;} break;
        case "Round 100": while ( level.round_number < 90 )   {wait 100; time += 100000;} while ( level.round_number < 100 )  {wait 1; time += 1000;} break;
        case "Round 125": while ( level.round_number < 120 )  {wait 100; time += 100000;} while ( level.round_number < 125 )  {wait 1; time += 1000;} break;
        case "Round 130": while ( level.round_number < 120 )  {wait 100; time += 100000;} while ( level.round_number < 130 )  {wait 1; time += 1000;} break;
        case "Round 140": while ( level.round_number < 130 )  {wait 100; time += 100000;} while ( level.round_number < 140 )  {wait 1; time += 1000;} break;
        case "Round 150": while ( level.round_number < 140 )  {wait 100; time += 100000;} while ( level.round_number < 150 )  {wait 1; time += 1000;} break;
        case "Round 175": while ( level.round_number < 170 )  {wait 100; time += 100000;} while ( level.round_number < 175 )  {wait 1; time += 1000;} break;
        case "Round 200": while ( level.round_number < 190 )  {wait 100; time += 100000;} while ( level.round_number < 200 )  {wait 1; time += 1000;} break;
    }
    level.fraga_splits_time = time;
    return time;
}


wait_first_split( split )
{
    time = 0;
    switch ( split )
    {
        case "Round 2":   while ( level.round_number < 2 )    {wait 1; time += 1000;} break;
        case "Round 3":   while ( level.round_number < 3 )    {wait 1; time += 1000;} break;
        case "Round 4":   while ( level.round_number < 4 )    {wait 1; time += 1000;} break;
        case "Round 5":   while ( level.round_number < 5 )    {wait 1; time += 1000;} break;
        case "Round 10":  while ( level.round_number < 10 )   {wait 1; time += 1000;} break;
        case "Round 15":  while ( level.round_number < 15 )   {wait 1; time += 1000;} break;
        case "Round 20":  while ( level.round_number < 20 )   {wait 1; time += 1000;} break;
        case "Round 25":  while ( level.round_number < 25 )   {wait 1; time += 1000;} break;
        case "Round 30":  while ( level.round_number < 30 )   {wait 1; time += 1000;} break;
        case "Round 40":  while ( level.round_number < 40 )   {wait 1; time += 1000;} break;
        case "Round 50":  while ( level.round_number < 50 )   {wait 1; time += 1000;} break;
        case "Round 60":  while ( level.round_number < 60 )   {wait 1; time += 1000;} break;
        case "Round 70":  while ( level.round_number < 70 )   {wait 1; time += 1000;} break;
        case "Round 80":  while ( level.round_number < 80 )   {wait 1; time += 1000;} break;
        case "Round 90":  while ( level.round_number < 90 )   {wait 1; time += 1000;} break;
        case "Round 100": while ( level.round_number < 100 )  {wait 1; time += 1000;} break;
        case "Round 125": while ( level.round_number < 125 )  {wait 1; time += 1000;} break;
        case "Round 130": while ( level.round_number < 130 )  {wait 1; time += 1000;} break;
        case "Round 140": while ( level.round_number < 140 )  {wait 1; time += 1000;} break;
        case "Round 150": while ( level.round_number < 150 )  {wait 1; time += 1000;} break;
        case "Round 175": while ( level.round_number < 175 )  {wait 1; time += 1000;} break;
        case "Round 200": while ( level.round_number < 200 )  {wait 1; time += 1000;} break;
    }
    level.fraga_splits_time = time;
    return time;
}

splitFinish( split_name, time )
{
    if(isDefined(level.total_split_time))
        level.total_split_time += time;
    if(!isDefined(level.total_split_time))
        level.total_split_time = time;

    level.fraga_splits_splits[split_name].finished = 1;
    if(!isDefined(level.finished_splits))
        level.finished_splits = 0;
    level.finished_splits += 1;
    level.fraga_splits_splits[split_name].color =  ( 0, 1, 1 );
    level.fraga_splits_splits[split_name] settext( game_time_string( level.total_split_time + 12000 /* 12 seconds for round change */) );
}

StartSplit( split_name )
{
    flag_wait( "initial_blackscreen_passed" );
    level.fraga_splits_splits[split_name] settenthstimerup( 0.1 );
}

game_time_string(duration)
{
    time_string = "";
	total_sec = int(duration / 1000);
	total_min = int(total_sec / 60);
	total_hours = int(total_min / 60);
	remaining_ms = int(duration % 1000 / 10);
    remaining_sec = int(total_sec % 60);
    remaining_min = int(total_min % 60);

	if(total_hours > 0)
	{
        if(total_hours <= 9 && total_hours != 0) {time_string += "0" + total_hours + ":";}
        if(total_hours > 9) {time_string += total_hours + ":";}
        if(remaining_min <= 9) {time_string += "0" + remaining_min + ":";}
        if(remaining_min > 9) {time_string += remaining_min + ":";}
        if(remaining_sec <= 9) {time_string += "0" + remaining_sec;}
        return time_string;
	}

	else
	{
		if(total_min > 0)
		{

			if(remaining_min < 9 && remaining_sec < 9 && remaining_ms < 9) {time_string = "0" + remaining_min + ":" + "0" + remaining_sec; return time_string;}
			if(remaining_min < 9 && remaining_sec < 9) {time_string = "0" + remaining_min + ":" + "0" + remaining_sec + "." + remaining_ms; return time_string;}
			if(remaining_min < 9 && remaining_ms < 9) {time_string = "0" + remaining_min + ":" + remaining_sec; return time_string;}
			if(remaining_sec < 9 && remaining_ms < 9) {time_string = remaining_min + ":" + "0" + remaining_sec; return time_string;}
			if(remaining_min < 9) {time_string = "0" + remaining_min + ":" + remaining_sec + "." + remaining_ms; return time_string;}
			if(remaining_sec < 9) {time_string = remaining_min + ":" + "0" + remaining_sec + "." + remaining_ms; return time_string;}
			if(remaining_ms < 9) {time_string = remaining_min + ":" + remaining_sec; return time_string;}
		}
		else
		{
			if(remaining_ms < 9) {time_string = remaining_sec; return time_string;}
			else {time_string = remaining_sec + "." + remaining_ms; return time_string;}
		}
	}

	return time_string;
}

show_splits()
{
    self endon("disconnect");
    splits_finished = 0;
    while(true)
    {
        wait 0.1;

        if(splits_finished == level.finished_splits && getDvarInt("splits") == 0)
            wait 0.1;

        if(splits_finished != level.finished_splits && getDvarInt("splits") == 0)
        {
            for(i = 1; i > 0.1; i -= 0.02)
            {
                foreach(split in level.fraga_splits_splits)
                    split.alpha = split.finished * i;
                wait 0.3;
            }   
            foreach(split in level.fraga_splits_splits)
                split.alpha = 0;
            splits_finished = level.finished_splits;
        }
        if(getDvarFloat("splits") > 0)
        {
            foreach(split in level.fraga_splits_splits)
                split.alpha = getDvarFloat("splits");
        }
    }
}