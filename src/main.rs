use std::io::{Read, Write};
use std::net::TcpListener;

fn main() {
    let listener = TcpListener::bind("0.0.0.0:8080").expect("Failed to bind port 8080");
    println!("Rust app listening on port 8080");

    for stream in listener.incoming() {
        let mut stream = stream.expect("Failed to accept connection");
        let mut buffer = [0; 512];
        let _ = stream.read(&mut buffer);

        let response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nHello from Rust CI pipeline on OpenShift!\n";
        stream.write_all(response.as_bytes()).unwrap_or(());
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
