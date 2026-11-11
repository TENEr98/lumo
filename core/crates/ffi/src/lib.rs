//! lumo-ffi: единственная публичная поверхность ядра для Swift (UniFFI).

uniffi::setup_scaffolding!("lumo_core");

/// Версия ядра. Тестовая функция задачи 0.2: проверяет, что мост Rust → Swift работает.
#[uniffi::export]
pub fn core_version() -> String {
    env!("CARGO_PKG_VERSION").to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn core_version_matches_package() {
        assert_eq!(core_version(), "0.1.0");
    }
}
