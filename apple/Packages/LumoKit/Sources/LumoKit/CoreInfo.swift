import LumoCore

/// Сведения о Rust-ядре. В задаче 0.2 — проверка, что мост UniFFI работает.
public enum CoreInfo {
    public static var version: String { coreVersion() }
}
