
export enum ModalType{
    SIMPLE
}

export interface ModalConfig {
    id: number,
    name:  string,
    type: ModalType,
    header: string,
    body: string,
    footer: string,
    onClose: Function,
    onOk: Function,
    okLabel: string,
    cancelLabel: string,
    clickPoint: {
        x: number,
        y: number
    }
}