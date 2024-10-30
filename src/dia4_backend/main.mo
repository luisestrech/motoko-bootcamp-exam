import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Result "mo:base/Result";

actor {
  
  type User = (Text, Nat);
  var users: [User] = [
    ("Adrian", 36),
    ("Luis", 18)
  ];
  //Persistion de datos
  stable var name: Text = ""; //Al usar la palabra reservada stable, es para que se quede guardada el valor de la variable aunque se reinicie

  public shared func setName(newname : Text): async () {
    name := newname;
  };

  public shared query func getName(): async Text {
    return name;
  };

  public shared func deleteName(): async () {
    name := "";
  };

  //Autentucaciones en internet identity
  public shared query ({caller}) func whoAmI(): async Principal {
    return caller;
  };

  type GetUsersResult = Result.Result<[User], Text>;
  //Validacion y Manejo de errores
  public shared query ({caller}) func getUsers(): async GetUsersResult {
    Debug.print("Caller: " # Principal.toText(caller));
    if (Principal.isAnonymous(caller)) {
      Debug.print("Anonymous User");
      return #err("You must be authenticated to get users");
    };

    Debug.print("Authenticated User");
    return #ok(users);
  };
};
