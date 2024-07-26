import { Button, Navbar } from "flowbite-react";
import { useHref, useMatch } from "react-router-dom";

function AppLink({ to, children }: { to: string, children: React.ReactNode }) {
    const path = useHref(to);
    const isMatch = useMatch(to) !== null;

    return(
        <Navbar.Link href={path} active={isMatch}>
            {children}
        </Navbar.Link>
    )

}


export default function TopBar() {
    return (
        <Navbar fluid rounded >
            <Navbar.Brand>STAT</Navbar.Brand>
            <div className="absolute inset-x-0 flex justify-center">
                <Navbar.Collapse>
                    <AppLink to="feed">Feed</AppLink>
                    <AppLink to="reflection">Reflection</AppLink>
                </Navbar.Collapse>
            </div>
            <div className="flex space-x-4">
                <Button>Logout</Button>
            </div>
        </Navbar>
    )
}