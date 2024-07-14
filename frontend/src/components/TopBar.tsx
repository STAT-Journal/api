import { Button, Navbar } from "flowbite-react";
import { useHref, useMatch } from "react-router-dom";
import { router } from "../routes/Router";

function AppLink({ to, children }: { to: string, children: React.ReactNode }) {
    const path = useHref(to);
    const isMatch = useMatch(to) !== null;

    return(
        <Navbar.Link href={path} active={isMatch}>
            {children}
        </Navbar.Link>
    )

}

function capitalizeFirstLetter(string: String) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

// Add function as method for strings
declare global {
    interface String {
        capitalizeFirstLetter(): string;
    }
}

String.prototype.capitalizeFirstLetter = function() {
    return capitalizeFirstLetter(this);
}


export default function TopBar() {
    // Todo: clear null checking and raise if not found

    return (
        <Navbar fluid rounded >
            <Navbar.Brand>STAT</Navbar.Brand>
            <div className="absolute inset-x-0 flex justify-center">
                <Navbar.Collapse>
                {router?.routes[0].children?.map((route) => (
                    <AppLink key={route.path} to={route.path?route.path:""}>{route.path?.capitalizeFirstLetter()}</AppLink>
                ))}
                </Navbar.Collapse>
            </div>
            <div className="flex space-x-4">
                <Button>Logout</Button>
            </div>
        </Navbar>
    )
}