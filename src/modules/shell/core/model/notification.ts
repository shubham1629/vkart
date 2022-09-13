export enum NotificationType{
    SIMPLE
}

export interface NotificationConfig {
    id: number,
    type: NotificationType,
    autoCloseTimer: number,
    classes: string
}