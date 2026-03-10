fn main() {
    println!("Hello from Rust CI pipeline on OpenShift!");
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
