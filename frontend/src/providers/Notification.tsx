import { notification } from "antd";
import { NotificationInstance } from "antd/es/notification/interface";
import { useContext, ReactElement, createContext } from "react";


export interface NotificationContext {
    api: NotificationInstance,
}

const NotificationContext = createContext<NotificationContext | undefined>(undefined);

export const NotificationProvider = ({ children }: { children: ReactElement}) => {
  const [api, contextHolder] = notification.useNotification();

  return (
    <NotificationContext.Provider value={{ api }}>
        {contextHolder}
        {children}
    </NotificationContext.Provider>
  );
};

export const useNotification = () => {
    const context = useContext(NotificationContext);
    if (!context) {
        throw new Error("useNotification must be used within a NotificationProvider");
    }
    return context;
};