export interface NavItemConfig {
    symbol?: string,
    title: string,
    route: string
}

export interface NavConfig {
    items: NavItemConfig[]
}