import Iter "mo:stdlib/iter";
import Debug "mo:stdlib/debug";
import Array "mo:stdlib/array";

actor universe {
    type cell = { #dead; #alive};
    type universe = {
                     var width : Nat;
                     var height : Nat;
                     var cells : [var cell];
                     };
 
    let universe : universe ={
        var width : Nat = 0;
        var height : Nat = 0;
        var cells : [var cell] = [var]  };

    public func populate(width : Nat, height : Nat): async (){
        universe.width := width;
        universe.height := height;
        universe.cells := Array.tabulateVar<cell>(width*height,func(index: Nat){
            if ((index % 2 == 0) or (index % 7 == 0)){
                #alive
            }else{
                #dead
            }
        } );        
    };

    public func render() : async Text{
        var output : Text = "";
        var current_row: Nat = 0;

        for (index in Iter.range(0,universe.cells.len()-1)){
            
            switch (universe.cells[index]){
                case (#dead){
                    output #= "◻";
                };
                case (#alive){
                    output #= "◼";
                };
            };

            if (get_row(index) > current_row){
                output #= "\n";
                current_row += 1;
            };
        };

        return output;
    };


    func get_index(row : Nat, column : Nat) : Nat {
        let index :Nat = row * universe.width + column;
        return index;
    };

    func get_row(index : Nat) : Nat{
        let row : Nat = index / universe.width;
        return row; 
    };

    func get_column(index : Nat) : Nat{
        let col : Nat = index % universe.height;
        return col;
    };

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

    func live_neighbour_count(row : Nat, column: Nat) : Nat{
        var count = 0;

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

        let nw = get_index(north, west);
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

        return count;
    };

    func tick(): [var cell] {
        var old_universe_cells = Array.tabulateVar<cell>(universe.width*universe.height, func(index:Nat){
            universe.cells[index]
        });
        universe.cells := Array.tabulateVar<cell>((universe.width*universe.height), func(index : Nat){
            let row = get_row(index);
            let col = get_column(index);
            let live_neighbours = live_neighbour_count(row,col);
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
        return old_universe_cells;
    };

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

    public func start() : async (){
        label draw_loop while(true){
            let old_universe_cells = tick();

            if (Array_equalsVar<cell>(old_universe_cells, universe.cells, cellEq)){
                break draw_loop;
            };
            draw();
        };
    };

    func Array_equalsVar<A>(
        a : [var A],
        b : [var A],
        eq : (A, A) -> Bool
    ) : Bool {
        if (a.len() != b.len()) {
            return false
        };
        var i = 0;
        while (i < a.len()) {
            if (not eq(a[i], b[i])) {
                return false
            };
            i += 1
        };
        true
    };

    func cellEq(a : cell, b : cell) : Bool {
        switch (a, b) {
            case (#dead, #dead) true;
            case (#alive, #alive) true;
            case (#dead, #alive) false;
            case (#alive, #dead) false;
        }
    };
};