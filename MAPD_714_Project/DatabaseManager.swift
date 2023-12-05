import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createNewUserLoginTable()
        createGuestLoginTable()
        createCruiseSelectedTable()
        createGuestInformationSelectedTable()
    }

    private func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("FinalProject.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
    }

    private func createNewUserLoginTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS NewUserLogin (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                address TEXT,
                city TEXT,
                country TEXT,
                phone TEXT,
                email TEXT,
                password TEXT
            );
        """

        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating NewUserLogin table")
        }
    }
    
    private func createCruiseSelectedTable() {
            let createTableQuery = """
                CREATE TABLE IF NOT EXISTS CruiseSelected (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    cruiseName TEXT,
                    visitingPlace TEXT,
                    price TEXT,
                    duration TEXT
                );
            """

            if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
                print("Error creating CruiseSelected table")
            }
        }

    private func createGuestLoginTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS GuestLogin (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                address TEXT,
                city TEXT,
                country TEXT,
                phone TEXT,
                email TEXT,
                password TEXT
            );
        """

        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating GuestLogin table")
        }
    }
    
    private func createGuestInformationSelectedTable() {
            let createTableQuery = """
                CREATE TABLE IF NOT EXISTS GuestInformationSelected (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    adults INTEGER,
                    kids INTEGER,
                    seniors INTEGER
                );
            """

            if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
                print("Error creating GuestInformationSelected table")
            }
        }

    // MARK: - Insert Methods

    func insertIntoNewUserLogin(name: String, address: String, city: String, country: String, phone: String, email: String, password: String) {
        let insertQuery = """
            INSERT INTO NewUserLogin (name, address, city, country, phone, email, password)
            VALUES ('\(name)', '\(address)', '\(city)', '\(country)', '\(phone)', '\(email)', '\(password)');
        """

        if sqlite3_exec(db, insertQuery, nil, nil, nil) != SQLITE_OK {
            print("Error inserting data into NewUserLogin table")
        }
    }

    func insertIntoGuestLogin(name: String, address: String, city: String, country: String, phone: String, email: String, password: String) {
        let insertQuery = """
            INSERT INTO GuestLogin (name, address, city, country, phone, email, password)
            VALUES ('\(name)', '\(address)', '\(city)', '\(country)', '\(phone)', '\(email)', '\(password)');
        """

        if sqlite3_exec(db, insertQuery, nil, nil, nil) != SQLITE_OK {
            print("Error inserting data into GuestLogin table")
        }
    }
    
    func insertIntoCruiseSelected(cruiseName: String, visitingPlace: String, price: String, duration: String) {
        let insertQuery = """
            INSERT INTO CruiseSelected (cruiseName, visitingPlace, price, duration)
            VALUES ('\(cruiseName)', '\(visitingPlace)', '\(price)', '\(duration)');
        """

        if sqlite3_exec(db, insertQuery, nil, nil, nil) != SQLITE_OK {
            print("Error inserting data into CruiseSelected table")
        }
    }
    
    func insertIntoGuestInformationSelected(adults: Int, kids: Int, seniors: Int) {
            let insertQuery = """
                INSERT INTO GuestInformationSelected (adults, kids, seniors)
                VALUES (\(adults), \(kids), \(seniors));
            """

            if sqlite3_exec(db, insertQuery, nil, nil, nil) != SQLITE_OK {
                print("Error inserting data into GuestInformationSelected table")
            }
        }


    // MARK: - Update Methods

    func updateNewUserLogin(name: String, email: String, newPassword: String) {
        let updateQuery = """
            UPDATE NewUserLogin
            SET password = '\(newPassword)'
            WHERE name = '\(name)' AND email = '\(email)';
        """

        if sqlite3_exec(db, updateQuery, nil, nil, nil) != SQLITE_OK {
            print("Error updating data in NewUserLogin table")
        }
    }

    func updateGuestLogin(name: String, email: String, newPassword: String) {
        let updateQuery = """
            UPDATE GuestLogin
            SET password = '\(newPassword)'
            WHERE name = '\(name)' AND email = '\(email)';
        """

        if sqlite3_exec(db, updateQuery, nil, nil, nil) != SQLITE_OK {
            print("Error updating data in GuestLogin table")
        }
    }

    // MARK: - Fetch Methods

    func getMostRecentUserData(tableName: String) -> [String: Any]? {
        var result: [String: Any]?

        let selectQuery = "SELECT * FROM \(tableName) ORDER BY id DESC LIMIT 1;"

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                result = [:]

                for i in 0..<sqlite3_column_count(statement) {
                    let columnName = String(cString: sqlite3_column_name(statement, i))
                    let columnValue = String(cString: sqlite3_column_text(statement, i))

                    result?[columnName] = columnValue
                }
            }
        }

        sqlite3_finalize(statement)

        return result
    }
    
    func getMostRecentCruiseSelectedData() -> [String: Any]? {
            return getMostRecentUserData(tableName: "CruiseSelected")
        }
    
    func getMostRecentGuestInformationSelectedData() -> [String: Any]? {
            return getMostRecentUserData(tableName: "GuestInformationSelected")
        }
    
    
    // MARK: - Update Recent Save Method

        func updateMostRecentUserData(tableName: String, newData: [String: Any]) {
            guard let mostRecentUserData = getMostRecentUserData(tableName: tableName),
                  let id = mostRecentUserData["id"] as? Int else {
                print("Error retrieving most recent user data")
                return
            }

            var updateQuery = "UPDATE \(tableName) SET "

            for (columnName, columnValue) in newData {
                updateQuery += "\(columnName) = '\(columnValue)', "
            }

            // Remove the trailing comma and space
            updateQuery.removeLast(2)

            updateQuery += " WHERE id = \(id);"

            if sqlite3_exec(db, updateQuery, nil, nil, nil) != SQLITE_OK {
                print("Error updating most recent data in \(tableName) table")
            }
        }

    deinit {
        sqlite3_close(db)
    }
}
