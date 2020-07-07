import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Array "mo:base/Array";

actor universe {
    // variant type declaration
    // "#dead" is shorthand for "#dead : ()" where () is the unit type
    type cell = { #dead; #alive};

    // universe object-type declaration
    // universe is an object that consists of 3 type-fields 
    // namely mutables with the annotated types
    // e.g. width is a mutable of type Nat
    type universe = {
                     var width : Nat;
                     var height : Nat;
                     var cells : [cell];
                     };
 
    // initalizing the universe of type universe
    // this has to meet the specification of the declared time from above 
    let universe : universe ={
        var width : Nat = 0;
        var height : Nat = 0;
        // cells functions as a flat matrix
        var cells : [cell] = []  };

    // this is part of the public API, other canisters ( so called inter-canister call) and people
    // can call this method from the outside (if they are allowed to by the canister)
    // note the async keyword fater the arguments
    public func populate(width : Nat, height : Nat): async (){
        universe.width := width;
        universe.height := height;
        // with this we will populate the array with values, those values are the 
        // variants we declared above
        universe.cells := Array.tabulate<cell>(width*height,func(index: Nat){
            if ((index % 2 == 0) or (index % 7 == 0)){
                #alive
            }else{
                #dead
            }
        } );        
    };

    // this renders the current state of the universe to a formatted string
    // it is asynchronous as it doesn't alter the canisters state
    // only internal state is modified
    public query func render() : async Text{
        var output : Text = "\n";
        var current_row: Nat = 0;

        for (index in Iter.range(0,universe.cells.size()-1)){
            
            if (get_row(index) > current_row){
                output #= "\n";
                current_row += 1;
            };
            switch (universe.cells[index]){
                case (#dead){
                    output #= "◻";
                };
                case (#alive){
                    output #= "◼";
                };
            };

        };

        return output;
    };

    // return the cells array
    public query func get_universe(): async [cell]{
        return universe.cells;
    };

    // asynchronous tick, this alters the canisters state
    public func tick(): async [cell] {
        // we safe the old universe so we can  operate on it
        var old_universe_cells = Array.tabulate<cell>(universe.width*universe.height, func(index:Nat){
            universe.cells[index]
        });
        // here we create the universe after the tick
        // tabulate takes the length n of the new array and 
        // a function that describes how to populate it.
        // this function will be fed the indices 0...n-1
        universe.cells := Array.tabulate<cell>((universe.width*universe.height), func(index : Nat){
            let row = get_row(index);
            let col = get_column(index);
            let live_neighbours = live_neighbour_count(row,col);
            // those are basically the game of life rules written in code.
            // here it is decided wheter a cell will be dead or alive after the
            // tick
            let new_state = switch (old_universe_cells[index], live_neighbours){
                case ((#alive, 2) or (#alive, 3)){
                    #alive;
                };
                case (#alive, x){
                    #dead;
                };
                case (#dead, 3){
                    #alive;
                };
                case (otherwise, _){
                    otherwise;
                };
            };
        });
        return universe.cells;
    };

    // this starts the game in a loop for the command line output
    // notice that only the start function is exposed to the outside.
    // this way the synchronous variant is way quicker
    public func start() : async (){
        //we safe the state of the current universe
        var old_universe_cells : [cell] = universe.cells;
        label draw_loop while(true){
            // snyc 
            var temp = sync_tick();
            if (Array.equal<cell>(old_universe_cells, temp, cellEq)){
                break draw_loop;
            };
            old_universe_cells := temp;
            draw();
        };
    };

    // a async query function, these functions return very quick as
    // they do not alter the state of the canister
    public query func get_width(): async Nat{
        return universe.width;
    };

    public query func get_height(): async Nat{
        return universe.height;
    };

    // calculate the next state of the universe
    // this function is synchronous and only available from inside the
    // canister or the command line
    func sync_tick(): [cell] {
        // safe the current state of the universe to "old_universe_cells"
        // so we dont overwrite old values with new values, which would chnange
        // the overall outcome
        var old_universe_cells = Array.tabulate<cell>(universe.width*universe.height, func(index:Nat){
            universe.cells[index]
        });
        // calculate the universe after the tick
        // array.tabulate takes to arguments: the first is the size n of the array, the second
        // a function that describes how to populate it for each index 0...n-1
        universe.cells := Array.tabulate<cell>((universe.width*universe.height), func(index : Nat){
            let row = get_row(index);
            let col = get_column(index);
            let live_neighbours = live_neighbour_count(row,col);

            // this decides if a cell is dead or alive in the next tick
            // depending on its neighbours. these are basically
            // the rules of game of life written in code
            let new_state = switch (old_universe_cells[index], live_neighbours){
                case ((#alive, 2) or (#alive, 3)){
                    #alive;
                };
                case (#alive, x){
                    #dead;
                };
                case (#dead, 3){
                    #alive;
                };
                case (otherwise, _){
                    otherwise;
                };
            };
        });
        return universe.cells;
    };

    // get the cells array index of a cell, given the row and column 
    func get_index(row : Nat, column : Nat) : Nat {
        let index :Nat = row * universe.width + column;
        return index;
    };

    // get the row of a cell in the grid
    func get_row(index : Nat) : Nat{
        let row : Nat = index / universe.width;
        return row; 
    };

    // get the column of a cell in the grid
    func get_column(index : Nat) : Nat{
        let col : Nat = index % universe.height;
        return col;
    };

    // this returns 1 if a cell is alive, else 0
    func get_count(idx : Nat) : Nat{
        var count = 0;
        switch (universe.cells[idx])   {
            case (#alive){
                count += 1;
            };
            case (#dead){
                count += 0;
            };
        };
        return count;          
    };

    // this function counts the live neighbours of a cell
    func live_neighbour_count(row : Nat, column: Nat) : Nat{
        var count = 0;

        // decide what north should be
        // if we are in the first row, north should be 
        // the row above it, which is the last row (imagine a SNAKE grid ;) )
        let north = if (row == 0) {
            universe.height - 1
        } else {
            row - 1
        };

        let south = if (row == universe.height - 1) {
            0
        } else {
            row + 1
        };

        let west = if (column == 0) {
            universe.width - 1
        } else {
            column - 1
        };

        let east = if (column == universe.width - 1) {
            0
        } else {
            column + 1
        };

        // north west is the upper left cell from the cell we are looking at
        // +-----+-------+------+
        // | NW  |  N    |   NE |
        // |     |       |      |
        // +--------------------+
        // |  W  |  XXX  |  E   |
        // |     |  XXX  |      |
        // +--------------------+
        // |   SW|   S   | SE   |
        // |     |       |      |
        // +-----+-------+------+

        // get_index() gets the index nw of the (north,west) 
        // cell inside the cells array
        let nw = get_index(north, west);
        // checks if the cell is dead or alive
        count += get_count(nw);

        let n = get_index(north, column);
        count += get_count(n);

        let ne = get_index(north, east);
        count += get_count(ne);

        let w = get_index(row, west);
        count += get_count(w);

        let e = get_index(row, east);
        count += get_count(e);

        let sw = get_index(south, west);
        count += get_count(sw);

        let s = get_index(south, column);
        count += get_count(s);

        let se = get_index(south, east);
        count += get_count(se);

        // this is the total count of alive neighbour cells
        // from the cell we are currently looking at.
        // we need this to decide the status of our cell in the next epoch
        return count;
    };

    // internal method that is accessible via command line, but not from the outside.
    // this basically draws a grid on the command line  
    func draw(): (){
        var output : Text = "\n  ____\n";
        for (row in Iter.range(0,universe.height-1)){
            var temp : Text = "| ";
            for (col in Iter.range(0,universe.width-1)){
                let idx = get_index(row,col);
                switch ( universe.cells[idx]){
                    case(#dead){
                        temp #= "O";
                    };
                    case(#alive){
                        temp #= "X";
                    };
                };
            };
            output #= temp # " |\n";
        };
        Debug.print(output#"  ____");
    };

    // function that decides wether two cells are equal
    func cellEq(a : cell, b : cell) : Bool {
        switch (a, b) {
            case (#dead, #dead) true;
            case (#alive, #alive) true;
            case (#dead, #alive) false;
            case (#alive, #dead) false;
        }
    };
};