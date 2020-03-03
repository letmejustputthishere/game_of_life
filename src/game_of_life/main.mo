import Iter "mo:stdlib/iter";
import Debug "mo:stdlib/debug";

actor universe {
    type universe = {
                     width : Nat;
                     height : Nat;
                     cells : [Bool] 
                     };

    var universe : universe ={
        width = 4;
        height = 4;
        cells = [true, false, true, false,
                false, false, false, true,
                true, false, false, false,
                true, false, false, true] 
    };


    public func get_index(row : Nat, column : Nat) : async Nat {
        return row * universe.width + column;
    };

    public func live_neighbour_count(column : Nat, row : Nat) : async Nat{
        var count = 0;
        label outer for (delta_row in Iter.range(0,universe.height-1)){
            label inner for (delta_col in Iter.range(0,universe.width-1)){
                if (delta_col == 0) continue inner;

                let neighbour_row = (row +delta_row) % universe.height;
                let neighbour_col = (column + delta_col) % universe.width;
                let idx = await get_index(neighbour_row, neighbour_col);

                count += if(universe.cells[idx]) 1 else 0;
                Debug.print(debug_show(count));
            };
        };
        return 0;
    };


};