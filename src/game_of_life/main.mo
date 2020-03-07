import Iter "mo:stdlib/iter";
import Debug "mo:stdlib/debug";
import Array "mo:stdlib/array";

actor universe {
    type cell = { #dead; #alive};
    type universe = {
                     width : Nat;
                     height : Nat;
                     cells : [var cell] 
                     };
 
    let universe : universe ={
        width = 4;
        height = 4;
        cells = [var 
                #dead, #alive, #alive, #dead,
                #dead, #alive, #alive, #alive,
                #dead, #dead, #dead, #dead,
                #alive, #alive, #alive ,#dead
                ];
    };


    func get_index(row : Nat, column : Nat) : Nat {
        let index :Nat = row * universe.width + column;
        return index;
    };

    func live_neighbour_count(column : Nat, row : Nat) : Nat{
        var count = 0;
        label outer for (delta_row in Iter.range(0,universe.height-1)){
            label inner for (delta_col in Iter.range(0,universe.width-1)){
                if (delta_col == 0 and delta_row == 0) continue inner;
                let neighbour_row = (row +delta_row) % universe.height;
                let neighbour_col = (column + delta_col) % universe.width;
                let idx = get_index(neighbour_row, neighbour_col);
                
                switch (universe.cells[idx])   {
                    case (#alive){
                        count += 1;
                    };
                    case (#dead){
                        count += 0;
                    };
                };           
            };
        };
        return count;
    };

    func tick(): universe {
        let old_universe = universe;
        for (row in Iter.range(0,old_universe.height-1 )){
            for (col in Iter.range(0,old_universe.width-1)){
                let idx = get_index(row,col);
                let live_neighbours = live_neighbour_count(row,col);
                switch (old_universe.cells[idx], live_neighbours){
                    case ((#alive, 2) or (#alive,3)){
                        universe.cells[idx] := #alive;
                    };
                    case (#alive, x){
                        if (x < 2){
                            universe.cells[idx] := #dead;
                        }else{
                            universe.cells[idx] := #dead;
                        }
                    };
                    case (#dead, 3){
                        universe.cells[idx] := #alive;
                    };
                    case (otherwise, _){
                        universe.cells[idx] := otherwise;
                    };
                };
            };
        };
        return old_universe;
    };

    func draw(): (){
        var output : Text = "\n____\n\n";
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
        Debug.print(output#"\n____");
    };

    public func start() : async (){
        label draw_loop while(true){
            var old_universe = tick();
            Debug.print(debug_show(old_universe));
            Debug.print(debug_show(universe));

            if (Array_equalsVar<cell>(old_universe.cells, universe.cells, cellEq)){
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